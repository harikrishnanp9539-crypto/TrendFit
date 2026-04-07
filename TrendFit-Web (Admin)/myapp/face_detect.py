# I've left some code in comments so that it can be easier if one wants to test and see output at various points. To make things simpler just remove the commented code !

def detect_face(img):
    import cv2


    # cascPath = "C:\\Users\\mehthaz\\PycharmProjects\\trendfit\\myapp\\haarcascade_frontalface_default.xml"
    cascPath = "D:\\trendfit\\myapp\\haarcascade_frontalface_default.xml"
    # cascPath = "C:\\Users\\aiswa\\PycharmProjects\\trendrove\\myapp\\haarcascade_frontalface_default.xml"


    faceCascade = cv2.CascadeClassifier(cascPath)

    image = img


    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Detect faces
    faces = faceCascade.detectMultiScale(
        gray,
        scaleFactor=1.1,
        minNeighbors=5,
        minSize=(30,30)
    )

    print("Found {0} faces !".format(len(faces)))


    for(x,y,w,h) in faces:
        cv2.rectangle(image, (x,y),(x+w,y+h),(255,255,255),0)

    sub_face = image[y:y+h, x:x+w]


    del(cv2)
    return sub_face

