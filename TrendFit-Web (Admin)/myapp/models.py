from django.db import models

# Create your models here.

class Login(models.Model):
    username=models.CharField(max_length=100)
    password=models.CharField(max_length=100)
    type=models.CharField(max_length=100)

class Category(models.Model):
    categoryname=models.CharField(max_length=100)

class Tones(models.Model):
    tonename=models.CharField(max_length=100)

class Complaint(models.Model):
    date=models.DateField()
    complaint=models.CharField(max_length=100)
    reply=models.CharField(max_length=100)
    status=models.CharField(max_length=100)
    LOGIN=models.ForeignKey(Login,on_delete=models.CASCADE)



class User(models.Model):
    username = models.CharField(max_length=100)
    place = models.CharField(max_length=100)
    post = models.CharField(max_length=100)
    pincode = models.BigIntegerField()
    district = models.CharField(max_length=100)
    gender = models.CharField(max_length=50)
    phone = models.BigIntegerField()
    email = models.CharField(max_length=100)
    age = models.CharField(max_length=100)
    height = models.CharField(max_length=100)
    photo = models.CharField(max_length=100)
    LOGIN=models.ForeignKey(Login,on_delete=models.CASCADE)




class Reviews(models.Model):
    USER = models.ForeignKey(User,on_delete=models.CASCADE)
    date = models.DateField()
    rating= models.CharField(max_length=100)
    review = models.CharField(max_length=500,default="")



class Measurements(models.Model):
    USER = models.ForeignKey(User, on_delete=models.CASCADE)
    date=models.DateField()
    m1 = models.CharField(max_length=100)
    m2 = models.CharField(max_length=100)
    m3 = models.CharField(max_length=100)
    m4 = models.CharField(max_length=100)
    m5 = models.CharField(max_length=100)
    m6 = models.CharField(max_length=100)
    m7 = models.CharField(max_length=100)
    m8 = models.CharField(max_length=100)
    m9 = models.CharField(max_length=100)
    m10 = models.CharField(max_length=100)


class Ordermain(models.Model):
    amount= models.CharField(max_length=100)
    USER= models.ForeignKey(User, on_delete=models.CASCADE)
    date = models.DateField()

class Dress(models.Model):
    name = models.CharField(max_length=100)
    size = models.CharField(max_length=100)
    type = models.CharField(max_length=100)
    photo = models.CharField(max_length=100)
    gender = models.CharField(max_length=100,default="")
    price = models.CharField(max_length=100)
    TONES=models.ForeignKey(Tones,on_delete=models.CASCADE)


class Ordersub(models.Model):
    ORDERMAIN= models.ForeignKey(Ordermain, on_delete=models.CASCADE)
    DRESS= models.ForeignKey(Dress, on_delete=models.CASCADE)
    quantity= models.CharField(max_length=100)


class payment(models.Model):
    ORDERMAIN= models.ForeignKey(Ordermain, on_delete=models.CASCADE)
    USER= models.ForeignKey(User, on_delete=models.CASCADE)
    amount = models.CharField(max_length=100)
    status= models.CharField(max_length=100)
    date=models.DateField()


class cart(models.Model):
    USER= models.ForeignKey(User, on_delete=models.CASCADE)
    DRESS= models.ForeignKey(Dress, on_delete=models.CASCADE)
    size= models.CharField(max_length=100)
    quantity= models.IntegerField()


class MyDress(models.Model):
    name = models.CharField(max_length=100)
    type = models.CharField(max_length=100)
    photo = models.CharField(max_length=100)
    USER= models.ForeignKey(User, on_delete=models.CASCADE)







