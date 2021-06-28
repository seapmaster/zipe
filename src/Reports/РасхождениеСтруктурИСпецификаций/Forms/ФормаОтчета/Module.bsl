
&НаСервере
Процедура ДобавитьВОчередьНаСервере()
	
	
	СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Отчет").СхемаКомпоновкиДанных;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	НастройкиКомпоновщика = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	НастройкиКомпоновщика.Структура.Очистить();
	НоваяГруппировка = НастройкиКомпоновщика.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	
	ПолеГруппировки = НоваяГруппировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
    ПолеГруппировки.Использование = Истина;
    ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ИзделиеПС");
	
	ВыбранноеПоле = НоваяГруппировка.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));   
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ИзделиеПС");
	
	//НовыйОтбор = НастройкиКомпоновщика.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОшибкаОбработки");
	//НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//НовыйОтбор.ПравоеЗначение = Ложь;
	//НовыйОтбор.Использование = Истина;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновщика, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных; 
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
    ПроцессорВывода.ОтображатьПроцентВывода = Истина;
	

	
	ТЗ = Новый ТаблицаЗначений; 
	
	ПроцессорВывода.УстановитьОбъект(ТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Если ТЗ.Количество() > 1000 Тогда
		Сообщить("В очередь помещена только первая 1000 элементов");
	КонецЕсли; 
	
	
	//Для каждого Стр Из ТЗ Цикл
	Для Сч = 0 По Мин(ТЗ.Количество(),1000) - 1 Цикл
		
		Стр = ТЗ[Сч];
		
		МЗ = РегистрыСведений.СпецификацииПредметовСнабженияОчередьИзменений.СоздатьМенеджерЗаписи();
		МЗ.Период = ТекущаяДата();
		МЗ.ПредметСнабжения = Стр.ИзделиеПС;
		МЗ.Записать(Истина);
		
	КонецЦикла; 

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВОчередь(Команда)
	ДобавитьВОчередьНаСервере();
КонецПроцедуры
