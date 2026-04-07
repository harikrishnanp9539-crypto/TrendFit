import smtplib
from math import sqrt


from django.core.files.storage import FileSystemStorage
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render, redirect

from trendfit import settings
from  .models import *
from datetime import datetime
# Create your views here.

def logout(request):
    request.session['lid']=''
    return HttpResponse('''<script>alert('logout successfull');window.location='/myapp/login/'</script>''')


def login(request):
    return render(request,'loginindex.html')


def login_post(request):
    username=request.POST['username']
    password=request.POST['password']
    print(request.POST)
    lobj=Login.objects.filter(username=username,password=password)
    if lobj.exists():
        log1=Login.objects.get(username=username,password=password)
        request.session['lid']=log1.id
        if log1.type=='admin':
            return HttpResponse('''<script>alert('login successfull');window.location='/myapp/adminhome/'</script>''')

    return HttpResponse('''<script>alert('login unsuccessfull');window.location='/myapp/login/'</script>''')

def adminhome(request):
    if request.session['lid']=='':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    return render(request, 'admin/newindex.html')


def Add_tone(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    return render(request, 'Admin/Add tones.html')

def Add_tone_post(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')

    name = request.POST['textfield']
    # photo = request.FILES['fileField']

    # fs=FileSystemStorage()
    # date=datetime.now().strftime('%y%m$d-%H%M%S')
    # fs.save(date,photo)
    # path=fs.url(date)


    tobj=Tones()



    tobj.tonename=name
    # tobj.tonephoto=path
    tobj.save()



    return HttpResponse('''<script>alert('tone added successfully');window.location='/myapp/adminhome/'</script>''')

def edit_tone(request,id):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    data=Tones.objects.get(id=id)
    return render(request, 'Admin/edit tone.html', {'data':data})

def edit_tone_post(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    name = request.POST['textfield']
    id=request.POST['id']

    tobj = Tones.objects.get(id=id)
    tobj.tonename = name
    tobj.save()

    return HttpResponse(''''<script>alert('edited successfully');window.location='/myapp/view_tone/'</script>''')

def delete_tone(request,id):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    Tones.objects.filter(id=id).delete()
    return redirect('/myapp/view_tone/')


def Category_add(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    return render(request, 'Admin/manage category.html')

def Category_add_post(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    name = request.POST['textfield']

    cobj=Category()
    cobj.categoryname=name
    cobj.save()
    return HttpResponse('''<script>alert('category added successfully');window.location='/myapp/adminhome/'</script>''')


def Category_view(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    data=Category.objects.all()
    return render(request, 'Admin/category view.html', {'data':data})

def Category_view_POST(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    search = request.POST['textfield']
    res = Category.objects.filter(categoryname__icontains=search)
    return render(request, 'Admin/category view.html', {'data':res})




def Category_delete(request,id):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    data=Category.objects.get(id=id).delete()

    return HttpResponse('''<script>alert('category deleted successfully');window.location='/myapp/Category_view/'</script>''')



def Category_edit(request,id):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    data=Category.objects.get(id=id)

    return render(request, 'Admin/category edit.html', {'data':data})

def Category_edit_post(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    id=request.POST['id']
    name=request.POST['textfield']

    cobj=Category.objects.get(id=id)
    cobj.categoryname=name
    cobj.save()

    return HttpResponse('''<script>alert('category updated successfully');window.location='/myapp/Category_view/'</script>''')

def Change_password(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    return render(request, 'Admin/change password.html')

def Change_password_post(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    current_password=request.POST['textfield']
    new_password=request.POST['textfield2']
    confirm_password=request.POST['textfield3']
    id=request.session['lid']

    chp=Login.objects.get(id=id)
    if chp.password==current_password:
        if new_password==confirm_password:

            Login.objects.filter(id=id).update(password=new_password)
            return HttpResponse('''<script>alert('password changed successfull');window.location='/myapp/login/'</script>''')
        else:
            return HttpResponse('''<script>alert('invalid password');window.location='/myapp/Change_password/'</script>''')
    else:
        return HttpResponse('''<script>alert('you must login first');window.location='/myapp/login/'</script>''')


def manage_category(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    return render(request, 'Admin/manage category.html')

def send_reply(request,id):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    return render(request, 'Admin/send reply.html', {"id":id})

def send_reply_post(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    r=request.POST['textarea']
    id=request.POST['id']
    Complaint.objects.filter(id=id).update(status='replied',reply=r)
    return HttpResponse('''<script>alert('replied');window.location='/myapp/view_complaint/'</script>''')


def view_complaint (request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    data=Complaint.objects.all()
    l=[]
    for i in data:
        ll=Login.objects.get(id=i.LOGIN.id)
        na=User.objects.get(LOGIN_id=i.LOGIN.id).username
        l.append({
        'id':i.id,
        'name':na,
        'date': i.date,
        'complaint': i.complaint,
        'reply': i.reply,
        'status': i.status,

            })

    return render(request, 'Admin/view complaint.html', {"data":data})


def view_complaint_post(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    fdate=request.POST['textfield']
    tdate=request.POST['textfield2']
    data = Complaint.objects.filter(date__range=[fdate,tdate])
    l = []
    for i in data:
        ll = Login.objects.get(id=i.LOGIN.id)
        if ll.type == "user":
            na = User.objects.get(LOGIN_id=i.LOGIN.id).username
            l.append({
                'id': i.id,
                'name': na,
                'date': i.date,
                'complaint': i.complaint,
                'reply': i.reply,
                'status': i.status,

            })

    return render(request, 'Admin/view complaint.html', {"data": l})

def view_reviews(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    return render(request, 'Admin/View reviews.html')



def view_tone(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    res=Tones.objects.all()
    return render(request, 'Admin/view tone.html', {"data":res})


def view_tone_POST(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    search =request.POST['textfield']
    res=Tones.objects.filter(tonename__icontains=search)
    return render(request, 'Admin/view tone.html', {"data":res})




def view_user(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    data=User.objects.all()
    return render(request, 'Admin/view user.html', {'data':data})


def view_user_POST(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    search=request.POST['textfield']
    data=User.objects.filter(username__icontains=search)
    return render(request, 'Admin/view user.html', {'data':data})


def view_review(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    data=Reviews.objects.all()
    print(data)
    return render(request, 'admin/View reviews.html', {'data':data})

def view_review_POST(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    fdate=request.POST['datefield1']
    tdate=request.POST['datefield2']
    data=Reviews.objects.filter(date__range=[fdate,tdate])
    return render(request, 'admin/View reviews.html', {'data':data})



def add_dress(request):
    data=Tones.objects.all()
    data1=Category.objects.all()

    return render(request, 'Shop/add dress.html', {"data":data,'data1':data1})


def add_dress_post(request):
    dname=request.POST.get('textfield')
    dsize=request.POST.get('textfield2')
    dtype=request.POST.get('category')
    dphoto=request.FILES.get('fileField')
    dprice=request.POST.get('textfield3')
    tid=request.POST.get('tone')
    dgender=request.POST.get('gender')
    fs = FileSystemStorage()
    date = datetime.now().strftime('%Y%m%d-%H%M%S') + '.jpg'
    fs.save(date, dphoto)
    path = fs.url(date)


    d=Dress()
    d.name=dname
    d.size=dsize
    d.type=dtype
    d.price=dprice
    d.TONES_id=tid
    d.photo=path
    d.gender=dgender
    d.save()
    return HttpResponse('''<script>alert('Added successfully.');window.location='/myapp/adminhome/'</script>''')


def edit_dress(request,id):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    data=Dress.objects.get(id=id)
    data1 = Category.objects.all()
    return render(request, 'Shop/edit dress.html', {'data':data,'data1':data1})

def edit_dress_post(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    ddress=request.POST['textfield']
    size=request.POST['textfield2']
    type=request.POST['category']
    gender=request.POST['gender']
    price=request.POST['textfield3']
    id=request.POST['id']
    data=Dress.objects.get(id=id)
    if 'photo' in request.FILES:
        photo = request.POST['fileField']
        fs = FileSystemStorage()
        date = datetime.now().strftime('%Y%m%d-%H%M%S') + '.jpg'
        fs.save(date, photo)
        path = fs.url(date)
        data.photo = path
        data.save()
    data.name=ddress
    data.size=size
    data.type=type
    data.gender=gender
    data.price=price
    data.save()
    return HttpResponse('''<script>alert('dress editted');window.location='/myapp/view_dress/'</script>''')

def view_dress(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    data=Dress.objects.all()
    return render(request, 'Shop/view dress.html', {'data':data})

def deleted_dress(request,id):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    Dress.objects.get(id=id).delete()
    return HttpResponse('''<script>alert('deleted succesfully');window.location='/myapp/view_dress/'</script>''')



def view_dress_post(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    search =request.POST['textfield']
    data=Dress.objects.filter(name__icontains=search)
    return render(request, 'Shop/view dress.html', {'data': data})


def view_ordermain(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    data=Ordermain.objects.all()
    return render(request,'Shop/view order(main).html',{'data':data})


def view_order_main_post(request):
    if request.session['lid'] == '':
        return HttpResponse('''<script>alert('please  login');window.location='/myapp/login/'</script>''')
    dfrom=request.POST['textfield']
    dto=request.POST['textfield2']
    data=Ordermain.objects.filter(date__range=[dfrom,dto])
    return render(request,'Shop/view order(main).html',{'data':data})

def view_ordersub(request,id):
    data=Ordersub.objects.filter(ORDERMAIN_id=id)
    return render(request,'Shop/view order(sub).html',{'data':data})

def view_ordersub_post(request):
    search=request.POST['textfield2']
    data=Ordersub.objects.filter(DRESS__name__icontains=search)
    return render(request,'Shop/view order(sub).html',{'data':data})




def view_order(request):
    return render(request,'Shop/view order(sub).html')

def view_order_post(request):
    data=""
    return render(request,'Shop/view order(sub).html')

def view_payment_method(request):
    data=payment.objects.all()
    return render(request,'Shop/view payment method.html',{'data':data})

def view_payment_method_post(request):
    fdate = request.POST['datefield1']
    tdate = request.POST['datefield2']

    data=payment.objects.filter(date__range=[fdate,tdate])
    return render(request,'Shop/view payment method.html',{'data':data})



###########################################################################33

def login_flutt(request):
    username=request.POST['username']
    password=request.POST['password']
    print(username,password)
    lobj=Login.objects.filter(username=username,password=password)
    if lobj.exists():
        log1=Login.objects.get(username=username,password=password)
        lid=log1.id
        if log1.type=='user':
            return JsonResponse({"status": "ok","lid":str(lid),"type":"user"})
        elif log1.type=='Deliveryboy':
            return JsonResponse({"status": "ok","lid":str(lid),"type":"Deliveryboy"})
        else:
            return JsonResponse({"status": "no"})
    else:
        return JsonResponse({"status": "no"})


def user_flutt(request):
    username=request.POST['Name']
    place=request.POST['Place']
    post=request.POST['Post']
    pincode=request.POST['Pincode']
    district=request.POST['District']
    phone=request.POST['Phone']
    email=request.POST['Email']
    gender=request.POST['Gender']
    password=request.POST['Password']
    confirm_password=request.POST['Confirmpassword']
    age=request.POST['Age']
    height=request.POST['height']

    photo=request.FILES["photo"]
    fs = FileSystemStorage()
    date = datetime.now().strftime('%Y%m%d-%H%M%S') + '.jpg'
    fs.save(date, photo)
    path = fs.url(date)

    if Login.objects.filter(username=email).exists():
        return JsonResponse({"status": "no"})

    l = Login()
    l.username = email
    l.password = confirm_password
    l.type = 'user'
    l.save()

    u = User()
    u.photo= fs.url(date)
    u.username = username
    u.place = place
    u.post = post
    u.pincode=pincode
    u.district=district
    u.phone=phone
    u.email=email
    u.gender=gender
    u.age=age
    u.LOGIN=l
    u.height=height
    u.save()

    return JsonResponse({"status": "ok"})

def view_profile_user(request):
    lid=request.POST['lid']
    obj=User.objects.get(LOGIN_id=lid)
    print(obj)
    return JsonResponse({"status": "ok",
                         "username":obj.username,
                         "place":obj.place,
                         "post":obj.post,
                         "pincode":obj.pincode,
                         "district":obj.district,
                         "age":obj.age,
                         "phone":obj.phone,
                         "email":obj.email,
                         "gender":obj.gender,
                         "height":obj.height,
                         "photo":obj.photo,



                         })


def edit_profile(request):
    username=request.POST['Name']
    place=request.POST['Place']
    post=request.POST['Post']
    pincode=request.POST['Pincode']
    district=request.POST['District']
    phone=request.POST['Phone']
    gender=request.POST['Gender']
    age=request.POST['Age']
    height=request.POST['height']
    lid=request.POST['lid']



    u = User.objects.get(LOGIN_id=lid)
    u.username = username
    if "photo" in request.FILES:

        photo = request.FILES["photo"]
        fs = FileSystemStorage()
        date = datetime.now().strftime('%Y%m%d-%H%M%S') + '.jpg'
        fs.save(date, photo)
        path = fs.url(date)
        u.photo=path

    u.place = place
    u.post = post
    u.pincode=pincode
    u.district=district
    u.phone=phone
    u.age=age
    u.gender=gender
    u.height=height

    u.save()

    return JsonResponse({"status": "ok"})


def user_Change_password_post(request):
    current_password=request.POST['current_password']
    new_password=request.POST['new_password']
    confirm_password=request.POST['confirm_password']
    id=request.POST['lid']

    chp=Login.objects.get(id=id)
    if chp.password==current_password:
        if new_password==confirm_password:

            Login.objects.filter(id=id).update(password=new_password)
            return JsonResponse({"status":"ok"})
        else:
            return JsonResponse({"status":"no"})
    else:
        return JsonResponse({"status": "no"})


def db_Change_password_post(request):
    current_password=request.POST['textfield1']
    new_password=request.POST['textfield2']
    confirm_password=request.POST['textfield3']
    id=request.POST['lid']

    chp=Login.objects.get(id=id)
    if chp.password==current_password:
        if new_password==confirm_password:

            Login.objects.filter(id=id).update(password=new_password)
            return JsonResponse({"status":"ok"})
        else:
            return JsonResponse({"status":"no"})
    else:
        return JsonResponse({"status": "no"})

def send_review(request):
    lid=request.POST['lid']
    review=request.POST['review']
    rating=request.POST['rating']

    r=Reviews()
    r.review=review
    r.rating=rating
    r.date=datetime.now().today()
    r.USER=User.objects.get(LOGIN_id=lid)
    r.save()
    return JsonResponse({"status": "ok"})


def add_to_cart_rec(request):
    lid=request.POST['lid']
    DRESS=request.POST['did']
    qid=1
    size="s"
    print(size)
    c=cart()
    c.quantity=qid
    c.DRESS_id=DRESS
    c.size=size
    c.USER=User.objects.get(LOGIN_id=lid)
    c.save()
    return JsonResponse({"status": "ok"})


def add_to_cart(request):
    lid=request.POST['lid']
    DRESS=request.POST['DRESS']
    qid=request.POST['Quantity']
    size=request.POST['selectedSize']
    print(size)
    c=cart()
    c.quantity=qid
    c.DRESS_id=DRESS
    c.size=size
    c.USER=User.objects.get(LOGIN_id=lid)
    c.save()
    return JsonResponse({"status": "ok"})

def send_complaint_user(request):
    lid=request.POST['lid']
    complaint=request.POST['complaint']
    print(complaint)

    r=Complaint()
    r.complaint=complaint
    r.reply="Waiting For Reply......"
    r.date=datetime.now()
    r.status="pending"
    r.LOGIN_id=lid
    r.save()
    return JsonResponse({"status": "ok"})


def view_reply_user(request):
    lid=request.POST['lid']
    res=Complaint.objects.filter(LOGIN_id=lid)
    l=[]
    for i in res:
        l.append({"id":i.id,"complaint":i.complaint,"date":i.date,"reply":i.reply,"status":i.status})

    return JsonResponse({"status": "ok","data":l})

# def

def add_my_dress_user(request):
    lid = request.POST['lid']
    dname=request.POST['name']
    dtype=request.POST['type']
    dphoto=request.POST['photo']

    from  datetime import datetime
    import base64
    date=datetime.now().strftime('%Y%m%d%H%M%S')+'.jpg'
    a=base64.b64decode(dphoto)
    fs=open("D:\\trendfit\\media\\Mydress\\"+date,"wb")
    path="/media/Mydress/"+date
    fs.write(a)
    fs.close()

    a=MyDress()
    a.name=dname
    a.type=dtype
    a.photo=path
    a.USER=User.objects.get(LOGIN_id=lid)
    a.save()
    return JsonResponse({"status": "ok"})



def view_dress_user(request):
    d = Dress.objects.all()
    l = []
    for i in d:
        l.append({
            "id": i.id,
            "name": i.name,
            "size": i.size,
            "type": i.type,
            "photo": i.photo,
            "price": i.price,
        })
    print(l)
    return JsonResponse({"status": "ok", "data": l})


def view_dress_rec(request):
    id=request.POST['id']
    d=Dress.objects.filter(id=id)
    # d = Dress.objects.all()
    l = []
    for i in d:
        l.append({
            "id": i.id,
            "name": i.name,
            "size": i.size,
            "type": i.type,
            "photo": i.photo,
            "price": i.price,
        })
    print(l)
    return JsonResponse({"status": "ok", "data": l})



def view_cart_and_order(request):
    lid = request.POST['lid']
    res = cart.objects.filter(USER__LOGIN_id=lid)
    l = []
    tot=0
    for i in res:
        t=int(i.DRESS.price)*int(i.quantity)
        tot+=t

        l.append({"id": i.id,
                  "quantity":i.quantity,
                  "Dress name":i.DRESS.name,
                  "Dress size":i.size,
                  "Dress type":i.DRESS.type,
                  "Dress_photo":i.DRESS.photo,
                  "Dress price":i.DRESS.price,
                  }

                 )
        print(tot)

    return JsonResponse({"status": "ok", "data": l,'tot':str(tot)})



def view_order_user(request):
    lid = request.POST['lid']
    data=Ordermain.objects.filter(USER__LOGIN_id=lid)
    li = []
    for i in data:
        li.append({
            'id':i.id,
            'amount':i.amount,
            'date':i.date,

        })

    return JsonResponse({"status": "ok","data": li})



def view_cart_user_more(request):
    oid = request.POST['oid']
    data = Ordersub.objects.filter(ORDERMAIN_id=oid)
    li = []

    for i in data:
        li.append({
            'id':i.id,
            'qty':i.quantity,
            'dress name':i.DRESS.name,
            'dress type':i.DRESS.type,
            'dress photo':i.DRESS.photo,
            'dress price':i.DRESS.price,
        })
        print(li),
    return JsonResponse({"status": "ok", "data": li})



def user_view_my_dress(request):
    lid=request.POST['lid']
    res = MyDress.objects.filter(USER__LOGIN_id=lid)
    l=[]
    for i in res:
        l.append({
            "id": i.id,
            "name": i.name,
            "type": i.type,
            "photo": i.photo,

        })

    return JsonResponse({"status": "ok", "data": l})


def  removemydress(request):
    id=request.POST['id']
    MyDress.objects.filter(id=id).delete()
    return JsonResponse({"status": "ok"})



def assign_order_tailor(request):
    lid = request.POST['lid']
    res = Ordersub.objects.filter(ORDERMAIN__USER__LOGIN_id=lid)
    l = []
    for i in res:
        l.append({"id": i.id,
                  "date": i.ORDERMAIN.date,
                  "Amount": i.ORDERMAIN.amount,
                  "shopname": i.ORDERMAIN.SHOP.shopname,
                  # "dressname": i.DRESS.name,
                  "quantity": i.quantity,

                  }

                 )
        print(l)

    return JsonResponse({"status": "ok", "data": l})





from django.http import JsonResponse
from datetime import datetime
from .models import cart, Ordermain, Ordersub, User, payment


from decimal import Decimal
from django.db import transaction
from django.http import JsonResponse
from django.utils import timezone
from datetime import datetime

def user_makepayment(request):
    lid = request.POST["lid"]

    # fetch all cart items for the user once
    cart_items = cart.objects.filter(USER__LOGIN_id=lid).select_related('DRESS', 'USER')

    if not cart_items.exists():
        return JsonResponse({'status': 'error', 'message': 'Cart is empty'})

    try:
        with transaction.atomic():
            # create Ordermain (amount will be updated after calculating)
            order_main = Ordermain()
            order_main.USER = User.objects.get(LOGIN_id=lid)
            order_main.date = timezone.now()
            order_main.amount = "0"   # temporary
            order_main.save()

            total_amount = Decimal('0.00')

            # create Ordersub rows and accumulate amount
            for item in cart_items:
                qty = Decimal(str(item.quantity))
                price = Decimal(str(item.DRESS.price))
                line_total = qty * price

                ordersub = Ordersub()
                ordersub.ORDERMAIN = order_main
                ordersub.DRESS = item.DRESS
                ordersub.quantity = item.quantity
                ordersub.save()

                total_amount += line_total

            # create single payment record for the order
            payment_obj = payment.objects.create(
                ORDERMAIN=order_main,
                date=timezone.now().date(),
                USER=User.objects.get(LOGIN_id=lid),
                amount=str(total_amount),
                status="paid"
            )

            # update the order main amount with the correct total
            order_main.amount = str(total_amount)
            order_main.save()

            # delete processed cart items
            cart_items.delete()

    except Exception as e:
        # log exception if you have logging; return error response
        return JsonResponse({'status': 'error', 'message': str(e)})

    return JsonResponse({'status': 'ok'})




def deletefromcart(request):
    id=request.POST['cid']
    cart.objects.filter(id=id).delete()
    return JsonResponse({'status':"ok"})


def recommendations(request):
    lid=request.POST["lid"]
    print(lid,"=======================================================================")
    Photo=request.POST['Photo']
    import datetime, base64
    a = base64.b64decode(Photo)
    dt = datetime.datetime.now().strftime('%Y%m%d%H%M%S%f') + '.jpg'
    open(settings.MEDIA_ROOT+"\\"+ dt, 'wb').write(a)

    # open("C:\\trendfit\\media\\"+dt,"wb").write(a)


    ####algitm
    from . import face_detect

    # from . import kMeansImgPy
    import cv2
    from . import allotSkinTone
    imgpath = settings.MEDIA_ROOT +"\\"+ dt
    print(imgpath,"hfdshfdazhfd")

    image = cv2.imread(imgpath)

    print(imgpath)

    # Detect face and extract
    face_extracted = face_detect.detect_face(image)
    # Pass extracted face to kMeans and get Max color list
    from . import kMeansImgPy
    colorsList = kMeansImgPy.kMeansImage(face_extracted)
    print("Main File : ")
    print("Red Component : " + str(colorsList[0]))
    print("Green Component : " + str(colorsList[1]))
    print("Blue Component : " + str(colorsList[2]))

    # Allot the actual skinTone to a certain shade
    allotedSkinToneVal = allotSkinTone.allotSkin(colorsList)
    print("alloted skin tone : ")
    print(allotedSkinToneVal)

    tones = [
        "Deep Espresso Brown",
        "Dark Brown",
        "Dusky Brown",
        "Medium Brown",
        "Warm Honey Brown",
        "Medium Wheat Brown",
        "Light Brown",
        "Golden Beige",
        "Light Ivory Brown",
        "Very Light Wheat",
    ]

    colors = [
        [76, 51, 35],  # tone1
        [95, 65, 45],  # tone2
        [120, 85, 60],  # tone3
        [140, 100, 70],  # tone4
        [155, 115, 85], # tone5
        [170, 135, 100],  # tone6
        [190, 155, 120],  # tone7
        [210, 180, 150],  # tone8
        [225, 200, 175],  # tone9
        [240, 220, 200]  # tone10
    ]

    mindex = colors.index(allotedSkinToneVal)
    print(tones[mindex])

    tone=tones[mindex]
    print(lid,"=======================================================================")

    ugender=User.objects.get(LOGIN_id=lid).gender
    print(tone,ugender,"heloooo")
    d = Dress.objects.filter(TONES__tonename=tone,gender=str(ugender).lower())
    print(d)
    l = []
    for i in d:
        l.append({'id': i.id,
                  'Dress name': i.name,
                  'Photo': i.photo,
                  'Price': i.price,
                  'size': i.size,
                  'dress type':i.type,

                  })
    print(l)
    return JsonResponse({'status': 'ok', 'data': l})





def user_dress_combinations(request):
    import numpy as np
    import tensorflow as tf
    from tensorflow import keras
    from tensorflow.keras import layers
    from tensorflow.keras.applications import ResNet50
    from tensorflow.keras.preprocessing import image
    from tensorflow.keras.applications.resnet50 import preprocess_input, decode_predictions

    # Load a pre-trained CNN model (ResNet-50)
    base_model = ResNet50(weights='imagenet', include_top=False)

    # Define a custom head for similarity computation
    inputs = keras.Input(shape=(224, 224, 3))
    x = base_model(inputs)
    x = layers.GlobalAveragePooling2D()(x)
    x = layers.Dense(512, activation='relu')(x)
    outputs = layers.Lambda(lambda x: tf.math.l2_normalize(x, axis=1))(x)  # L2 normalization
    model = keras.Model(inputs, outputs)

    # Load and preprocess dress images (replace these paths with your dataset)


    lid= request.POST["lid"]
    # lid="15"

    topdress= MyDress.objects.filter(USER__LOGIN_id= lid,type='Top')
    botdress= MyDress.objects.filter(USER__LOGIN_id= lid,type='Bottom')


    if not  ( len(topdress) >0 and len(botdress)>0):

        return JsonResponse({'status':'insuffcicientdresscount'})

    top_dress_image_paths = []

    bottom_dress_image_paths = []

    for i in topdress:
        top_dress_image_paths.append("D:\\trendfit\\media\\" +  i.photo.replace("/media/",""))
        print(top_dress_image_paths,"hellooooooo")

    for i in botdress:
        bottom_dress_image_paths.append("D:\\trendfit\\media\\" + i.photo.replace("/media/",""))

        # Function to load and preprocess an image
    def load_and_preprocess_image(image_path):
        try:
            img = image.load_img(image_path, target_size=(224, 224))
            img = image.img_to_array(img)
            img = preprocess_input(img)
            return img
        except Exception as e:
            print(f"Error loading image at path {image_path}: {e}")
            return None

    # Extract features for all top and bottom dresses
    top_dress_features = []
    bottom_dress_features = []

    for top_image_path in top_dress_image_paths:
        top_dress_img = load_and_preprocess_image(top_image_path)
        if top_dress_img is not None:
            top_dress_features.append(model.predict(np.expand_dims(top_dress_img, axis=0)))

    for bottom_image_path in bottom_dress_image_paths:
        bottom_dress_img = load_and_preprocess_image(bottom_image_path)
        if bottom_dress_img is not None:
            bottom_dress_features.append(model.predict(np.expand_dims(bottom_dress_img, axis=0)))

    # Calculate cosine similarity between all pairs of top and bottom dresses
    similarities = np.dot(np.vstack(top_dress_features), np.vstack(bottom_dress_features).T)

    # Display the similarity matrix
    print("Similarity Matrix:")
    print(similarities)

    # You can set a threshold to determine if the dresses match or not
    threshold =0.2
    # Adjust this threshold as needed


    ls=[]

    # Find and display matching combinations
    for i, top_similarities in enumerate(similarities):
        matching_bottom_indices = np.where(top_similarities >= threshold)[0]
        if matching_bottom_indices.any():
            ls.append({'top':topdress[i].photo ,'bottom':botdress[int(matching_bottom_indices[0])].photo   })
        else:
            print(f"No matching Bottom Dress found for Top Dress {i + 1}")

    print(ls,"ffghhjjkjkj")
    return JsonResponse({'status':'ok', 'data':ls})









def getdistance(x1, x2, y1, y2,):

    a= max([x2,x1])- min([x2,x1])
    b= max([y2,y1])- min([y2,y1])

    d =sqrt((a*a)+(b*b))

    return d





def poseestimation(request):

    # -----------------------------
    # 1. Get user id and image
    # -----------------------------
    lid = request.POST['lid']
    image = request.FILES['photo']

    from datetime import datetime
    from django.core.files.storage import FileSystemStorage
    from django.http import JsonResponse
    import cv2

    # -----------------------------
    # 2. Save image
    # -----------------------------
    fname = datetime.now().strftime("%Y%m%d%H%M%S") + ".jpg"
    fs = FileSystemStorage()
    fs.save(fname, image)

    imagepath = "D:\\trendfit\\media\\" + fname

    # -----------------------------
    # 3. Get user height
    # -----------------------------
    user = User.objects.get(LOGIN_id=lid)
    height_of_person = float(user.height)

    # -----------------------------
    # 4. Load OpenPose model
    # -----------------------------
    protoFile = "D:\\trendfit\\myapp\\openpose_pose_mpi_faster_4_stages.prototxt.txt"
    weightsFile = "D:\\trendfit\\myapp\\pose_iter_160000.caffemodel"
     #maybe it may not include due to size limitation download it from google and paste it to the root folder 
     # https://github.com/spmallick/learnopencv/blob/master/OpenPose/getModels.sh 

    net = cv2.dnn.readNetFromCaffe(protoFile, weightsFile)

    # -----------------------------
    # 5. Read image and process
    # -----------------------------
    frame = cv2.imread(imagepath)
    h, w, _ = frame.shape

    blob = cv2.dnn.blobFromImage(
        frame, 1 / 255, (368, 368), (0, 0, 0), swapRB=False
    )

    net.setInput(blob)
    output = net.forward()

    H = output.shape[2]
    W = output.shape[3]

    # -----------------------------
    # 6. Detect keypoints
    # -----------------------------
    points = []

    for i in range(16):
        probMap = output[0, i, :, :]
        _, prob, _, point = cv2.minMaxLoc(probMap)

        x = int((w * point[0]) / W)
        y = int((h * point[1]) / H)

        points.append((i, x, y))

        # Draw point
        cv2.circle(frame, (x, y), 8, (0, 255, 255), -1)
        cv2.putText(frame, str(i), (x, y),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 1)

    cv2.imwrite("as_coco.jpg", frame)

    # -----------------------------
    # 7. Height reference (pixel ratio)
    # -----------------------------
    try:
        head = points[0]
        foot = points[13]
        body_pixels = getdistance(head[1], foot[1], head[2], foot[2])
        pixel_ratio = body_pixels / height_of_person
    except:
        return JsonResponse({'status': 'error'})

    # -----------------------------
    # 8. Helper to calculate distance
    # -----------------------------
    def cal(p1, p2):
        return getdistance(
            points[p1][1], points[p2][1],
            points[p1][2], points[p2][2]
        )

    # -----------------------------
    # 9. Body measurements (in cm)
    # -----------------------------
    try:
        shoulder = cal(2, 5) / pixel_ratio
        upper_arm = cal(2, 3) / pixel_ratio
        lower_arm = cal(3, 4) / pixel_ratio
        left_arm = cal(5, 6) / pixel_ratio
        forearm = cal(6, 7) / pixel_ratio
        hip = cal(8, 11) / pixel_ratio
        thigh = cal(8, 9) / pixel_ratio
        knee = cal(9, 10) / pixel_ratio
        calf = cal(11, 12) / pixel_ratio
        ankle = cal(12, 13) / pixel_ratio
    except:
        return JsonResponse({'status': 'error'})

    # -----------------------------
    # 10. Save measurements
    # -----------------------------
    Measurements.objects.filter(USER=user).delete()

    m = Measurements()
    m.USER = user
    m.date = datetime.now().date()

    m.m1 = str(round(shoulder, 3))
    m.m2 = str(round(upper_arm, 3))
    m.m3 = str(round(lower_arm, 3))
    m.m4 = str(round(left_arm, 3))
    m.m5 = str(round(forearm, 3))
    m.m6 = str(round(hip, 3))
    m.m7 = str(round(thigh, 3))
    m.m8 = str(round(knee, 3))
    m.m9 = str(round(calf, 3))
    m.m10 = str(round(ankle, 3))

    m.save()

    return JsonResponse({'status': 'ok'})


def user_view_measurement(request):
    lid = request.POST['lid']
    a = Measurements.objects.filter(USER__LOGIN_id=lid)
    l = []

    for i in a:
        m1 = float(i.m1)   # <-- FIX HERE
        m8 = float(i.m8)   # <-- FIX HERE

        # Size detection
        if m1 < 36:
            k = "S"
        elif m1 < 38:
            k = "M"
        elif m1 < 40:
            k = "L"
        else:
            k = "XL"

        if m8 < 37:
            ks = "25"
        elif m8 < 39:
            ks = "27"
        elif m8 < 42:
            ks = "28"
        elif m8 < 45:
            ks = "32"
        else:
            ks = "34"

        # Append dictionary (fix indentation)
        l.append({
            'id': i.id,
            'm1': i.m1,
            'm2': i.m2,
            'm3': i.m3,
            'm4': i.m4,
            'm5': i.m5,
            'm6': i.m6,
            'm7': i.m7,
            'm8': i.m8,
            'm9': i.m9,
            'm10': i.m10,
            'date': i.date,
            'TS': k,
            'BS': ks
        })

    return JsonResponse({'status': 'ok', 'data': l})






def virtual_try(request):
    lid = request.POST["lid"]
    uimage = request.FILES["photo"]
    dimage = request.FILES["photo2"]

    from datetime import datetime
    fname = datetime.now().strftime("%Y%m%d%H%M%S") + "c.jpg"
    fname2 = datetime.now().strftime("%Y%m%d%H%M%S") + "u.jpg"
    fs = FileSystemStorage()
    person_image_path=fs.save(fname, dimage)
    dress_image_path=fs.save(fname2, uimage)


    person_path = "D:\\trendfit\\media\\"+person_image_path
    garment_path ="D:\\trendfit\\media\\"+dress_image_path
    print(person_path,'.................',garment_path,'.....')

    from gradio_client import Client, file
    client = Client(
        "yisol/IDM-VTON",
        hf_token="Your_Token" #hagging face token 
       
    )

    # Connect to the current live space
    # client = Client("yisol/IDM-VTON")   # or "yisol/IDM-VTON-multi" – same API

    result = client.predict(
        dict={  # ← This is the new "image layers" input
            "background": file(garment_path),  # ← Your full-body person photo (local file)
            "layers": [],  # ← Leave empty for single garment
            "composite": None
        },
        garm_img=file(person_path),  # ← Your garment image (local file)
        garment_des="",  # ← Text description (optional, leave empty if you upload image)
        is_checked=True,  # ← "Use garment image" checkbox
        is_checked_crop=False,  # ← Auto-crop person (usually False is better)
        denoise_steps=30,
        seed=42,
        api_name="/tryon"  # ← This endpoint name is still correct
    )

    print(result)  # ← This will be a temporary URL to the result image
    output_url = result
    print("Output image URL:", output_url[0])
    from PIL import Image
    img1 = Image.open(person_path)
    img2 = Image.open(garment_path)
    img3 = Image.open(output_url[0])
    size = 400
    imgs = [img.resize((size, size)) for img in [img1, img2, img3]]
    combined = Image.new("RGB", (size * 2, size * 2), "white")
    combined.paste(imgs[0], (0, 0))
    combined.paste(imgs[1], (size, 0))
    combined.paste(imgs[2], (0, size))  # bottom-left


    fname3 = datetime.now().strftime("%Y%m%d%H%M%S") + "out.jpg"

    imgs[2].save("D:\\trendfit\\media\\"+fname3)



    return JsonResponse(
        {
            'status':'ok',
            'photo':"/media/"+fname3
        }
    )
import os
import json
import traceback
import requests
from datetime import datetime

from django.http import JsonResponse
from django.core.files.base import ContentFile
from django.core.files.storage import FileSystemStorage

from gradio_client import Client, file
from gradio_client import exceptions as gradio_exceptions
from PIL import Image


# helper: save debug text to media for inspection
def _save_debug_text(fs: FileSystemStorage, name_prefix: str, text: str) -> str:
    fname = f"{name_prefix}_{datetime.now().strftime('%Y%m%d%H%M%S')}.txt"
    fs.save(fname, ContentFile(text.encode("utf-8")))
    return fname






def appforgotpassword_post(request):


    email=request.POST['email']
    print(email,'hhhhhhhhhhhh')


    if Login.objects.filter(username=email).exists():

        name=User.objects.get(email=email).username

        import random
        new_pass = random.randint(00000, 99999)
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login("trendfit01@gmail.com", " wyjv vslc ujjc ezel")  # App Password
        to = email
        cpass=name+"@"+str(new_pass)
        subject = "Test Email"
        body = "Your new password is " + str(cpass)
        msg = f"Subject: {subject}\n\n{body}"
        server.sendmail("s@gmail.com", to, msg)  # Disconnect from the server
        server.quit()

        Login.objects.filter(username=email).update(password=cpass)


        return JsonResponse({'status':'ok'})
    else:

        return JsonResponse({'status': 'no'})
