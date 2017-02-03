-- main global parameteres
screen_width, screen_height = canvas:attrSize()

grid = screen_width/32
start = false

tcpresult = ""

menuOn = false
pgmOn = false
mainIconState = 1
mainIconPos =1
_debug_ = true
version = "1.2.4t"

-- tcp metrics
require 'lib_tcp'

function countMetric()
  -- ping internet
  if start == false then
    tcp.execute(
      function ()
        tcp.connect('www.redeminas.mg.gov.br', 80)
        tcp.send('get /ginga.php?aplicacao=portal' .. version .. '\n')
        tcpresult = tcp.receive()
        --print(tcpresult)
        if tcpresult then
          tcpresult = tcpresult or '0'
        else
          tcpresult = 'er:' .. evt.error
        end
        canvas:flush()
        tcp.disconnect()
        start = true
      end
    )
  end
end

function shift(x,v,limit)
  -- not as num?
  if v == nil then v = 0 end
  if x + v < 1 then
    return x + v + limit
  elseif  x + v > limit  then
    return x + v - limit
  else
    return x+v
  end
end


--input a text string, get a lefty list
function textWrap(text,size)
  local list = {}
  local offset = 0
  local offsetSum = 0
  local lasti =0
  local lines = (math.floor(string.len(text)/size)+1)
  for i=1,lines do
    if (i==1) then
      result=string.sub(text,((i-1)*size),(i*size))
    else
      result=string.sub(text,(((i-1)*size-offsetSum)),(i*size+offsetSum))
    end
    -- calculate offset
    offset = 0
    if i ~= lines then
      while (string.sub(result,size-offset,size-offset) ~= " " ) do
        if offset < size then
          offset = offset +1
        end
      end
    end

    result = string.sub(result,0,size-offset)

    -- if line starts with space, remove it
    if string.sub(result,1,1) == " " or string.sub(result,1,1) == "," then
      result = string.sub(result,2,size+offset)
      --      elseif (string.sub(result,size+1,size+1) == ",") then
    end
    offsetSum = offsetSum + offset
    canvas:drawText(grid*6, grid*1.7+i*grid*0.7 , result)
    lasti = i
    list[i]=result
  end

  --resto
  result=string.sub(text,(((lasti)*size-offsetSum)),(lasti*size+offsetSum))
  list[lasti+1]=result
  return(list)
end



--based on http://lua-users.org/wiki/DayOfWeekAndDaysInMonthExample
function get_day_of_week(dd, mm, yy)
  dw=os.date('*t',os.time{year=yy,month=mm,day=dd})['wday']
  return dw,({"Dom","Seg","Ter","Qua","Qui","Sex","Sab" })[dw]
end

function get_days_in_month(mnth, yr)
  return os.date('*t',os.time{year=yr,month=mnth+1,day=0})['day']
end
