--- Harmonia object

harmoniaMenu = {}

function harmoniaMenu:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.pos = 1
  self.spos = 1
  self.icons=4
--  self.pgmicons = math.floor(screen_width/210)
--  self.list=layoutPgmTable(ReadTable("tbl_pgm.txt"))
  self.debug=false
  self.bar={}
  self.bar.stop=false
  self.repertorioItens=4
  --remove
  self.list=layoutPgmHarmonia(ReadTable("tbl_harmoniarepertorio.txt"))
--  self.settings=false
  return o
end

--deal with keys
function harmoniaMenu:input (evt)


  if (evt.key=="CURSOR_UP") then
    self.pos=shift(self.pos,-1,self.icons)
    self.bar.stop=true
    self:iconDraw()
  elseif ( evt.key=="CURSOR_DOWN") then
    self.pos=shift(self.pos,1,self.icons)
    self.bar.stop=true
    self:iconDraw()
  elseif ( self.pos==2 and evt.key == "CURSOR_LEFT" ) then
    self.spos=shift(self.spos,-1, #self.list)
    self:repertorio()
  elseif ( self.pos==2 and evt.key == "CURSOR_RIGHT" ) then
    self.spos=shift(self.spos,1, #self.list)
    self:repertorio()
    -- PGM
  elseif ( self.pos==4 ) then
    if ( evt.key == "RED" ) then
      self:menuItem('red')
    elseif ( self.pos==4 and evt.key == "GREEN" ) then
      self:menuItem('green')
    elseif ( self.pos==4 and evt.key == "YELLOW" ) then
      self:menuItem('yellow')
    elseif ( self.pos==4 and evt.key == "BLUE" ) then
      self:menuItem('blue')
    end
  end
end

-- harmonia icons vert scroll
function harmoniaMenu:iconDraw()
  if (not pgmOn) then
    canvas:attrColor(0,0,0,0)
    canvas:clear(0,0, grid*32, grid*18 )
    pgmOn = true
  end

  local sumdy=01

  local menu ={
    {desc="Edição da semana",width=250},
    {desc="Repertório",width=200},
    {desc="Villa Lobos",width=250},
    {desc="Contatos",width=220}
  }

  canvas:attrColor(93,196,179,217)
  canvas:clear(0,grid*11, grid*32, grid*18 )
  canvas:attrFont("Tiresias", 22,"bold")
  canvas:attrColor("white")

  for i=1,#menu  do
    -- icon on
    if i==self.pos then
      self.bar.y = ((grid*11.55)+((grid*i)))
      self.bar.width = menu[i].width
      self.bar.desc = menu[i].desc
      if i == 4 then
        menu[i].desc= ""
      end
      canvas:drawText((grid),(grid*11.8+(grid*(i-1))), menu[i].desc)
      barHorizontal()
    else
      if (i < 4) then
        canvas:drawText((grid),(grid*11.8+(grid*(i-1))), menu[i].desc)
      end
    end
  end

  local imgbgdleft = canvas:new("media/harmonia/bgd00.png")
  canvas:compose(0, grid*11, imgbgdleft )

  -- Draw nav buttons
  local btnarrowv = canvas:new("media/btnarrowv.png")
  --local btnarrowh = canvas:new("media/btnarrowh.png")
  local btnexit = canvas:new("media/btnsair.png")
  canvas:compose(grid, grid*17, btnarrowv)
  --  canvas:compose(grid*2.5, grid*17, btnarrowh)
  canvas:compose(grid*4, grid*17, btnexit)

  self:menuItem()
  --canvas:flush()
end

-- sub menu pgm draw carrossel
function harmoniaMenu:repertorio()
--  canvas:attrColor(0,0,0,0)
--  canvas:clear(0,0, grid*32, grid*11 )
--  canvas:attrColor(1,1,1,200)
--  canvas:clear(grid*6,grid*11.5, grid*32, grid*18 )

  for i=1,self.repertorioItens  do
    if i==1 then
      self:repertorioIcons(shift(self.spos-1,i,#self.list),i,true)
    else
      self:repertorioIcons(shift(self.spos-1,i,#self.list),i,false)
    end
  end

  -- icone +info
  if (self.list[self.spos]["info"] == true) then
    local imginfo = canvas:new("media/pgminfo.png")
    canvas:compose(grid*26.5, grid*17, imginfo )
  end
  -- icone youtube
  if (self.list[self.spos]["youtube"] == true) then
    local imginfo = canvas:new("media/btnred.png")
    canvas:compose(grid*28, grid*17, imginfo )
  end
  -- icone site
  if (self.list[self.spos]["site"] == true) then
    local imginfo = canvas:new("media/btngreen.png")
    canvas:compose(grid*29, grid*17, imginfo )
  end
  -- icone facebook
  if (self.list[self.spos]["facebook"] == true) then
    local imginfo = canvas:new("media/btnyellow.png")
    canvas:compose(grid*30, grid*17, imginfo )
  end
  -- icone twitter
  if (self.list[self.spos]["twitter"] == true) then
    local imginfo = canvas:new("media/btnblue.png")
    canvas:compose(grid*31, grid*17, imginfo )
  end

  --text
  canvas:attrFont("Vera", 21,"bold")
  canvas:attrColor("white")
  canvas:drawText(grid*6,grid*14, self.list[self.spos]["grupo"] )
  canvas:drawText(grid*18,grid*14, self.list[self.spos]["regente"])
  canvas:drawText(grid*24,grid*14, self.list[self.spos]["obras"])
  canvas:drawText(grid*6,grid*15, self.list[self.spos]["compositores"])
  canvas:drawText(grid*18,grid*15, self.list[self.spos]["data"])
  canvas:drawText(grid*24,grid*15, self.list[self.spos]["horario"])
  canvas:drawText(grid*6,grid*16, self.list[self.spos]["local"])
--  canvas:drawText(grid*18,grid*16, self.list[self.spos]["ingressso"])
--  canvas:drawText(grid*24,grid*16, self.list[self.spos]["info"])
  
  
  --texto grade
  canvas:drawText(grid*6,grid*17, self.list[self.spos]["desc"])


  canvas:flush()
end

function harmoniaMenu:repertorioIcons(t, slot, ativo)
  --setup parameters
  local item_h = 154
  local item_w = 85
  local icon = canvas:new("media/" .. string.format("%02d" , self.list[t]["img"]).. ".png")

  canvas:compose((grid*6+(item_w*(slot-1))+(2*grid*(slot-1))), grid*11.5, icon )

  if ativo then
    canvas:attrColor("red")
    canvas:drawRect("frame", grid*6, grid*11.5, item_h+1, item_w+1)
    canvas:drawRect("frame", grid*6-1, grid*11.5-1, item_h+2, item_w+2)
    canvas:drawRect("frame", grid*6-2, grid*11.5-2, item_h+3, item_w+3)
    canvas:drawRect("frame", grid*6-2, grid*11.5-2, item_h+4, item_w+4)
  end
end

-- main menu treatment
function harmoniaMenu:menuItem(par)
--  canvas:attrColor(0,0,0,0)
--  canvas:clear(0,0, grid*32, grid*10 )
  canvas:attrColor(93,196,179,217)
  canvas:clear(grid*7,grid*11, grid*32, grid*18 )

  -- edicao da semana
  if (self.pos==1) then
    local imgbgdr = canvas:new("media/harmonia/bgd0" .. math.random(4) .. ".png")
    canvas:compose(grid*7, grid*11, imgbgdr)
    local img = canvas:new("media/harmonia/edicaodasemana.png")
    canvas:compose(grid*7, grid*11, img)
    -- repertorio - agenda semanal
  elseif (self.pos == 2) then
    local imgbtnarrowh = canvas:new("media/btnarrowh.png")
    canvas:compose(grid*2.5, grid*17, imgbtnarrowh)
    local imgbgdr = canvas:new("media/harmonia/bgd0" .. math.random(4) .. ".png")
    canvas:compose(grid*7, grid*11, imgbgdr)
--    local img = canvas:new("media/harmonia/repertorio.png")
  --  canvas:compose(grid*7, grid*11, img)
    self:repertorio()
    -- especial do mes
  elseif (self.pos==3) then
    local imgbgdr = canvas:new("media/harmonia/bgd0" .. math.random(4) .. ".png")
    canvas:compose(grid*7, grid*11, imgbgdr)
    local img = canvas:new("media/harmonia/especialdomes.png")
    canvas:compose(grid*7, grid*11, img)
    -- contatos
  elseif (self.pos==4) then
    local imgbgdr = canvas:new("media/harmonia/bgd0" .. math.random(4) .. ".png")
    canvas:compose(grid*7, grid*11.5, imgbgdr)
    local img = canvas:new("media/harmonia/contatos.png")
    canvas:compose(grid*7, grid*11.5, img)
    if  par == 'red' then
      local img = canvas:new("media/qrfb.png")
      local dx,dy = img:attrSize()
      canvas:attrColor(0,0,0,0)
      canvas:clear(grid*32-dx,grid, dx, dy )
      canvas:compose(grid*32-dx, grid, img)
    elseif  par == 'green' then
      local img = canvas:new("media/qrtwitter.png")
      local dx,dy = img:attrSize()
      canvas:attrColor(0,0,0,0)
      canvas:clear(grid*32-dx,grid, dx, dy )
      canvas:compose(grid*32-dx, grid, img)
    elseif  par == 'yellow' then
      local img = canvas:new("media/qrinsta.png")
      local dx,dy = img:attrSize()
      canvas:attrColor(0,0,0,0)
      canvas:clear(grid*32-dx,grid, dx, dy )
      canvas:compose(grid*32-dx, grid, img)
    elseif  par == 'blue' then
      local img = canvas:new("media/qryoutube.png")
      local dx,dy = img:attrSize()
      canvas:attrColor(0,0,0,0)
      canvas:clear(grid*32-dx,grid, dx, dy )
      canvas:compose(grid*32-dx, grid, img)
    end
  end
  canvas:flush()
end

function barHorizontalAnim()
  local mult = 10
  for i=1,(harmonia.bar.width/mult) do
    if (pgmOn and not harmonia.bar.stop) then
      canvas:attrColor(255,255,255,255)
      canvas:clear(grid/2-3,harmonia.bar.y,(i*mult),2)
      canvas:flush()
      coroutine.yield(i) -- sleep...
    end
  end
end

function barHorizontalUpdate()
  print (coroutine.status(barHorizontalCoroutine))
  coroutine.resume(barHorizontalCoroutine)
  if   coroutine.status(barHorizontalCoroutine) ~= 'dead'  then
    event.timer(30,barHorizontalUpdate)
  end
end

--function barHorizontal(param)
function barHorizontal()
  harmonia.bar.stop=false
  barHorizontalCoroutine=coroutine.create(barHorizontalAnim)
  barHorizontalUpdate()
end
