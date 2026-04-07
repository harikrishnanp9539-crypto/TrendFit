from django.urls import path,include

from myapp import views

urlpatterns = [

    path('login/', views.login ),
    path('login_post/', views.login_post ),
    path('adminhome/', views.adminhome ),


    path('Add_tone/',views.Add_tone),
    path('Add_tone_post/',views.Add_tone_post),
    path('edit_tone/<id>',views.edit_tone),
    path('edit_tone_post/',views.edit_tone_post),
    path('delete_tone/<id>',views.delete_tone),
    path('Category_add/',views.Category_add),
    path('Category_add_post/',views.Category_add_post),
    path('Category_view/',views.Category_view),
    path('Category_view_POST/',views.Category_view_POST),
    path('Category_delete/<id>',views.Category_delete),
    path('Category_edit/<id>',views.Category_edit),
    path('Category_edit_post/',views.Category_edit_post),

    path('manage_category/',views.manage_category),


    path('Change_password/',views.Change_password),
    path('Change_password_post/',views.Change_password_post),

    path('send_reply/<id>',views.send_reply),
    path('send_reply_post/',views.send_reply_post),

    path('view_complaint/',views.view_complaint),
    path('view_complaint_post/',views.view_complaint_post),
    path('view_reviews/',views.view_reviews),

    path('view_tone/',views.view_tone),
    path('view_tone_POST/',views.view_tone_POST),
    path('view_user/',views.view_user),
    path('view_user_POST/',views.view_user_POST),
    path('logout/',views.logout),

    path('view_review/',views.view_review),
    path('view_review_POST/',views.view_review_POST),



    path('add_dress/', views.add_dress),
    path('add_dress_post/',views.add_dress_post),
    # path('change_password/', views.change_password),
    # path('Change_password_post/',views.Change_password_post),
    path('edit_dress/<id>', views.edit_dress),
    path('edit_dress_post/', views.edit_dress_post),
    path('view_dress/', views.view_dress),
    path('deleted_dress/<id>',views.deleted_dress),
    path('view_dress_post/',views.view_dress_post),
    path('view_ordermain/', views.view_ordermain),
    path('view_order_main_post/',views.view_order_main_post),
    path('view_ordersub/<id>', views.view_ordersub),
    path('view_ordersub_post/<id>', views.view_ordersub_post),
    path('view_order/', views.view_order),
    path('view_payment_method/', views.view_payment_method),
    # path('view_shop_profile/', views.view_shop_profile),
    path('view_payment_method_post/',views.view_payment_method_post),



######################FLUTTER

    path('login_flutt/', views.login_flutt),
    path('user_flutt/',views.user_flutt),
    path('view_profile_user/',views.view_profile_user),
    path('edit_profile/',views.edit_profile),
    path('send_review/',views.send_review),
    path('add_to_cart/',views.add_to_cart),

    path('user_flutt/',views.user_flutt),
    path('send_complaint_user/',views.send_complaint_user),
    path('view_reply_user/',views.view_reply_user),
    path('view_dress_user/',views.view_dress_user),
    path('add_my_dress_user/',views.add_my_dress_user),


    path('view_cart_and_order/',views.view_cart_and_order),
    path('view_order_user/',views.view_order_user),
    path('view_cart_user_more/',views.view_cart_user_more),


    path('user_view_my_dress/',views.user_view_my_dress),
    path('assign_order_tailor/',views.assign_order_tailor),
    path('recommendations/',views.recommendations),
    path('user_dress_combinations/',views.user_dress_combinations),
    path('poseestimation/',views.poseestimation),
    path('user_view_measurement/',views.user_view_measurement),
    path('user_Change_password_post/',views.user_Change_password_post),
    path('db_Change_password_post/',views.db_Change_password_post),
    path('user_makepayment/',views.user_makepayment),
    path('deletefromcart/',views.deletefromcart),


    path('virtual_try/',views.virtual_try),
    path('appforgotpassword_post/',views.appforgotpassword_post),
    path('removemydress/',views.removemydress),
    path('add_to_cart_rec/',views.add_to_cart_rec),
    path('view_dress_rec/',views.view_dress_rec),



]