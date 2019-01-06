from django.conf.urls import url 
from . import views
from testap.views import current_datetime, hours_ahead

urlpatterns = [
    url(r'^time/$', current_datetime),
    url(r'^$', views.post_list, name='post_list'),
    url(r'^time/plus/(\d{1,2})/$', hours_ahead),
   #url(r'^base/$',base



]

