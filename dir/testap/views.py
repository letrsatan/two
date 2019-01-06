from django.template.loader import get_template
from django.shortcuts import render
from django.http import HttpResponse, Http404
from django.template import Context
import datetime
from django.shortcuts import render_to_response


def current_datetime(request):
 now = datetime.datetime.now()
 return render_to_response('current_datetime.html', {'current_date': now})




#def current_datetime(request):
# now = datetime.datetime.now()
# html = "<html><body>Сейчас %s.</body></html>" % now
# return HttpResponse(html)


# Create your views here.
def post_list(request):
    return render(request, 'testap/post_list.html', {})


def hours_ahead(request, offset):
    try:
        offset = int(offset)
    except ValueError:
        raise Http404()
    dt = datetime.datetime.now() + datetime.timedelta(hours=offset)
   # ds = str(dt)
    return render_to_response('hours_ahead.html', {'hours_offset': offset}, {'next_time': dt})

  #html = "<html><body>Через %s. часов будет: %s. </body></html>" % (offset, dt)
    #return HttpResponse(html)


#def current_datetime(request):
 #now = datetime.datetime.now()
 #t = get_template('current_datetime.html')
 #html = t.render({'current_date' : now})
 #return HttpResponse(html)
