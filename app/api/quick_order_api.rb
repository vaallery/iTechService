class QuickOrderApi < Grape::API
  version 'v1', using: :path

  desc 'Quick Tasks list'
  get 'quick_tasks' do
    QuickTask.all.as_json(only: [:id, :name])
  end

  desc 'Create Quick Order'
  params do
    requires :quick_order
  end
  post 'quick_orders' do
    authenticate!
    authorize! :create, QuickOrder
    quick_order = QuickOrder.new(params[:quick_order])
    if quick_order.save
      pdf = QuickOrderPdf.new quick_order
      filepath = "#{Rails.root.to_s}/tmp/pdf/quick_order_#{quick_order.number}.pdf"
      pdf.render_file filepath
      PrinterTools.print_file filepath, :quick_order
      present quick_order
    else
      error!({error: quick_order.errors.full_messages.join('. ')}, 422)
    end
  end

  desc 'Create media menu order'
  params do
    requires :orders
  end
  post 'media_menu_orders' do
    orders = params[:orders]
    present orders
  end
  # classType:
  # 0 - книга
  # 1 - Приложение
  # 2 - Муз трек
  # 3 - эпизод телешоу
  # 4 - фильм
  # 5 - трек аудиокниги

  # {name: '', phone: '', items: [{classType: '', filmNumber: '', name: '', uid: ''}]}

  #<Hashie::Mash 060D87D6-4CF9-45C4-8F91-71EA7ECF2D2E=#<Hashie::Mash date="2014-08-09T14:19:10+1100" items=[#<Hashie::Mash classType=4 filmNumber=1 name="09 01 Философия сведения и пять инструментов для сведения" uid="3590">, #<Hashie::Mash classType=4 filmNumber=4 name="04 14 Работа со списком событий" uid="3584">] name="Арпм" phone=";());$"> 3083EDF7-BE0D-4943-BFD9-263E237DE267=#<Hashie::Mash date="2014-08-09T14:30:18+1100" items=[#<Hashie::Mash classType=4 filmNumber=4 name="04 14 Работа со списком событий" uid="3584">, #<Hashie::Mash classType=4 filmNumber=1 name="09 01 Философия сведения и пять инструментов для сведения" uid="3590">] name="Прол" phone="()$$&8&"> 597011F9-2294-44CA-A149-BBA89429A516=#<Hashie::Mash date="2014-08-09T14:32:23+1100" items=[#<Hashie::Mash classType=4 filmNumber=1 name="09 01 Философия сведения и пять инструментов для сведения" uid="3590">] name="Родпби" phone="$$;&&?&@'&("> 6ABA8128-33F2-480D-8923-ADF71ECD2797=#<Hashie::Mash date="2014-08-09T14:26:56+1100" items=[#<Hashie::Mash classType=4 filmNumber=4 name="04 14 Работа со списком событий" uid="3584">, #<Hashie::Mash classType=4 filmNumber=1 name="09 01 Философия сведения и пять инструментов для сведения" uid="3590">] name="Лиолл" phone="(67668778"> 7DC0CA03-30EF-4BE7-8680-49B1BB570BF4=#<Hashie::Mash date="2014-08-09T14:27:35+1100" items=[#<Hashie::Mash classType=4 filmNumber=1 name="09 01 Философия сведения и пять инструментов для сведения" uid="3590">, #<Hashie::Mash classType=4 filmNumber=4 name="04 14 Работа со списком событий" uid="3584">] name="Ооогр" phone="(677)$&"> 84BC5304-0D63-424D-BED1-EE07CC6861F7=#<Hashie::Mash date="2014-08-09T14:33:48+1100" items=[#<Hashie::Mash classType=4 filmNumber=1 name="09 01 Философия сведения и пять инструментов для сведения" uid="3590">, #<Hashie::Mash classType=4 filmNumber=4 name="04 14 Работа со списком событий" uid="3584">] name="Щгишришри" phone="$((8;68;86,"> DC93B1F3-914D-4F4C-969C-538DAB1DCA50=#<Hashie::Mash date="2014-08-09T14:33:05+1100" items=[#<Hashie::Mash classType=4 filmNumber=4 name="04 14 Работа со списком событий" uid="3584">, #<Hashie::Mash classType=4 filmNumber=1 name="09 01 Философия сведения и пять инструментов для сведения" uid="3590">] name="Мпрпмр" phone="(?))(()?"> DF9B75CA-09CE-44D5-B752-66B9EA4135EB=#<Hashie::Mash date="2014-08-09T14:32:47+1100" items=[#<Hashie::Mash classType=4 filmNumber=4 name="04 14 Работа со списком событий" uid="3584">, #<Hashie::Mash classType=4 filmNumber=1 name="09 01 Философия сведения и пять инструментов для сведения" uid="3590">] name="Лоиош" phone="5(?)$$!$"> F3EDBD5F-A51C-455D-B2EF-573ADFD1C15B=#<Hashie::Mash date="2014-08-09T14:25:27+1100" items=[#<Hashie::Mash classType=4 filmNumber=1 name="09 01 Философия сведения и пять инструментов для сведения" uid="3590">, #<Hashie::Mash classType=4 filmNumber=4 name="04 14 Работа со списком событий" uid="3584">] name="Оооолш" phone=")))))$$78">>

end