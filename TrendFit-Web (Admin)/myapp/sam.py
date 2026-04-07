# Assuming you have the person's photo and the dress photo loaded as PIL Image objects

from google import genai

# Replace "YOUR_FREE_API_KEY_HERE" with the actual string value of your key
from google.genai import types

MY_API_KEY = "AIzaSyBPc5vdtPqSFOpBQp0qQofIcQbLp4gvaIs"
client = genai.Client(api_key=MY_API_KEY)
from PIL import Image

person_image = Image.open(r"D:\trendfit\myapp\men.jpg")
dress_image = Image.open(r"D:\trendfit\myapp\dress.jpg")

# The MODEL_ID remains the same for both generation and editing/composition
MODEL_ID = "gemini-2.5-flash-image"

# 3. Craft the fusion prompt
fusion_prompt = (
    "Create a photorealistic image. Take the woman from the first image and have "
    "her wear the blue floral dress from the second image. Generate a full-body shot "
    "of the woman wearing the dress. Ensure the lighting and shadows are adjusted "
    "to match a realistic outdoor setting and the dress fits naturally."
)

# 4. Call the API with multiple inputs
response = client.models.generate_content(
    model=MODEL_ID,
    # The contents list contains the prompt and BOTH image objects
    contents=[fusion_prompt, person_image, dress_image],
    config=types.GenerateContentConfig(
        response_modalities=["IMAGE"]
    )
)
