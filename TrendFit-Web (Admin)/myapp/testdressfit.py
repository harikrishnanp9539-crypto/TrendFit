
import argparse
from PIL import Image, ImageDraw, ImageFilter
import numpy as np
import cv2
import mediapipe as mp
import torch
from diffusers import ControlNetModel, StableDiffusionControlNetInpaintPipeline, DDIMScheduler

def load_image(path, size=None):
    img = Image.open(path).convert("RGB")
    if size:
        img = img.resize(size, Image.LANCZOS)
    return img

def save_image(img, path):
    img.save(path)
    print("✅ Saved:", path)

def create_pose_map(person_img):
    mp_pose = mp.solutions.pose
    pose = mp_pose.Pose(static_image_mode=True, model_complexity=1)
    img_np = np.array(person_img)
    h, w = img_np.shape[:2]
    result = pose.process(cv2.cvtColor(img_np, cv2.COLOR_RGB2BGR))
    pose.close()
    canvas = Image.new("RGB", (w, h), (0, 0, 0))
    draw = ImageDraw.Draw(canvas, "RGB")
    if not result.pose_landmarks:
        print("⚠️ No pose landmarks found.")
        return canvas
    coords = [(int(lm.x * w), int(lm.y * h), lm.visibility) for lm in result.pose_landmarks.landmark]
    skeleton = [(11,13),(13,15),(12,14),(14,16),(11,12),(23,24),(11,23),(12,24)]
    for a,b in skeleton:
        ax,ay,av=coords[a]; bx,by,bv=coords[b]
        if av>0.3 and bv>0.3:
            draw.line((ax,ay,bx,by), fill=(255,255,255), width=max(6,h//100))
    return canvas

def create_torso_mask(person_img):
    mp_pose = mp.solutions.pose
    pose = mp_pose.Pose(static_image_mode=True, model_complexity=1)
    img_np = np.array(person_img)
    h,w=img_np.shape[:2]
    result = pose.process(cv2.cvtColor(img_np, cv2.COLOR_RGB2BGR))
    pose.close()
    mask = Image.new("L",(w,h),0)
    draw = ImageDraw.Draw(mask)
    if not result.pose_landmarks:
        draw.rectangle((0,0,w,h),fill=255)
        return mask
    lm=result.pose_landmarks.landmark
    pts=[(int(lm[i].x*w),int(lm[i].y*h)) for i in [11,12,24,23]]
    poly=np.array(pts,np.int32)
    centroid=poly.mean(axis=0)
    expanded=[tuple((centroid+(p-centroid)*1.4).astype(int)) for p in poly]
    draw.polygon(expanded,fill=255)
    mask=mask.filter(ImageFilter.GaussianBlur(radius=max(6,h//120)))
    return mask

def prepare_for_pipeline(img, target=512):
    w,h=img.size
    size=min(w,h)
    left=(w-size)//2; top=(h-size)//2
    img=img.crop((left,top,left+size,top+size)).resize((target,target),Image.LANCZOS)
    return img

def run_pipeline(person_path,dress_path,out_path,
                 sd_model="runwayml/stable-diffusion-v1-5",
                 controlnet_model="lllyasviel/sd-controlnet-openpose",
                 device="cpu",
                 guidance_scale=8.0,
                 num_inference_steps=40,
                 strength=1.0):

    person=load_image(person_path)
    dress=load_image(dress_path)

    print("🧍 Generating pose map & mask...")
    pose_map=create_pose_map(person)
    mask=create_torso_mask(person)

    person_in=prepare_for_pipeline(person)
    pose_in=prepare_for_pipeline(pose_map)
    mask_in=prepare_for_pipeline(mask.convert("RGB")).convert("L")

    print("🔄 Loading ControlNet & Stable Diffusion (CPU mode)...")
    controlnet=ControlNetModel.from_pretrained(controlnet_model, torch_dtype=torch.float32)
    pipe=StableDiffusionControlNetInpaintPipeline.from_pretrained(
        sd_model, controlnet=controlnet, torch_dtype=torch.float32
    )
    pipe.scheduler=DDIMScheduler.from_config(pipe.scheduler.config)
    pipe.to(device)

    prompt=(
        "Create a realistic photo of a person wearing the same outfit as shown in the reference image."
        " The clothing should appear to the person’s body, with accurate representation of fabric texture, color, and fine details."
        " Ensure high-quality, photo-realistic lighting and natural shadows for a lifelike appearance."
    )
    neg="blurry, bad anatomy, watermark, distorted, unrealistic, low quality"

    print("🎨 Generating...")
    generator=torch.Generator(device=device).manual_seed(123)
    result=pipe(
        prompt=prompt,
        negative_prompt=neg,
        image=person_in,
        mask_image=mask_in,
        control_image=pose_in,
        guidance_scale=guidance_scale,
        num_inference_steps=num_inference_steps,
        generator=generator,
        strength=strength
    )

    out=result.images[0].resize(person.size,Image.LANCZOS)
    save_image(out,out_path)
    print("✅ Done!")

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument("--person",default="men.jpg")
    parser.add_argument("--dress",default="dress.jpg")
    parser.add_argument("--out",default="output.png")
    args=parser.parse_args()
    run_pipeline(args.person,args.dress,args.out)

if __name__=="__main__":
    main()