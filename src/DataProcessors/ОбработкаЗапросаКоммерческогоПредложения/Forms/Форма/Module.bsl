
////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Заявка", Заявка) Тогда
		
		Элементы.Заявка.ТолькоПросмотр = Истина;
		
	КонецЕсли;

КонецПроцедуры //ПриСозданииНаСервере

////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если ПустаяСтрока(ПутьКФайлу) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для запуска обработки необходимо предварительно выбрать файл Microsoft Excel.'"), , "ПутьКФайлу");
		Возврат;
		
	КонецЕсли; 
	
	ПолучитьТаблицу();
	СформироватьТабличнуюЧастьПредметыСнабженияНаСервере();
	
КонецПроцедуры //Загрузить

&НаКлиенте
Процедура СоздатьКоммерческоеПредложение(Команда)
	
	Ошибки = Неопределено;
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Заявка) Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Заявка", НСтр("ru = 'Для создания документа необходимо выбрать заявку.'"), Неопределено);
				
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ЗапросНаКоммерческоеПредложение) Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ЗапросНаКоммерческоеПредложение", НСтр("ru = 'Для создания документа необходимо выбрать запрос на коммерческое предложение.'"), Неопределено);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НомерКП) Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "НомерКП", НСтр("ru = 'Для создания документа необходимо указать номер коммерческого предложения.'"), Неопределено);
		
	КонецЕсли;
			
	Если ТаблицаПредметыСнабжения.Количество() = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ТаблицаПредметыСнабжения", НСтр("ru = 'Нет данных для загрузки.'"), Неопределено);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Не Отказ Тогда
		
		СформироватьДокументКонтракт();

	КонецЕсли;
	
КонецПроцедуры // СоздатьКоммерческоеПредложение

////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = "Excel (*.xlsx;*.xls)|*.xlsx;*.xls";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		ПутьКФайлу = ДиалогОткрытияФайла.ВыбранныеФайлы[0];
				
	КонецЕсли;

КонецПроцедуры //ПутьКФайлуНачалоВыбора

&НаКлиенте
Процедура ПолучитьТаблицу()
	
	ТаблицаПредметыСнабжения.Очистить();
	
	Попытка
		
		Состояние("Загрузка Microsoft Excel...");
		ExcelПриложение = Новый COMОбъект("Excel.Application");
		
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при загрузке Microsoft Excel: %1'"), ОписаниеОшибки()); 				
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
	КонецПопытки;
	
	Попытка
		
		Состояние("Открытие файла Microsoft Excel...");
		ExcelФайл = ExcelПриложение.WorkBooks.Open(ПутьКФайлу);
		
		Состояние("Обработка файла Microsoft Excel...");
		ExcelЛист = ExcelФайл.Sheets(1);
		xlCellTypeLastCell = 11;
		ExcelПоследняяСтрока = ExcelЛист.Cells.SpecialCells(xlCellTypeLastCell).Row;
				
		Для Строка = 3 По ExcelПоследняяСтрока Цикл
			Состояние("Обработка файла Microsoft Excel : " + "строка " + Строка + " из " + ExcelПоследняяСтрока);
			
			ПредметСнабжения = 			ExcelЛист.Cells(Строка, 3).Value;
			Если НЕ ЗначениеЗаполнено(ПредметСнабжения) Тогда
				Продолжить;
			КонецЕсли;
			
			
			НоваяСтрока = ТаблицаПредметыСнабжения.Добавить();
			
			НоваяСтрока.Идентификатор 		= ExcelЛист.Cells(Строка, 1).Value;
			НоваяСтрока.Входимость			= ExcelЛист.Cells(Строка, 2).Value;
			НоваяСтрока.ПредметСнабжения 	= ExcelЛист.Cells(Строка, 3).Value;
			НоваяСтрока.ЕдиницаИзмерения 	= ExcelЛист.Cells(Строка, 5).Value;
			НоваяСтрока.ОбозначениеТУ	 	= ExcelЛист.Cells(Строка, 7).Value;
			
			НоваяСтрока.Количество	 		= СтрЗаменить(ExcelЛист.Cells(Строка, 6).Value, Символы.НПП,"");
			НоваяСтрока.СрокИзготовления   	= СтрЗаменить(ExcelЛист.Cells(Строка, 9).Value, Символы.НПП,"");
			НоваяСтрока.Цена   				= СтрЗаменить(ExcelЛист.Cells(Строка, 10).Value, Символы.НПП,"");
						
		КонецЦикла;
		
		
		ExcelФайл.Close();
		
	Исключение
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при открытии/чтении файла  %1: %2'"), ПутьКФайлу, ОписаниеОшибки()); 				
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);

	КонецПопытки;
	
	Состояние("Загрузка в БД...");
	
КонецПроцедуры //ПолучитьТаблицу 

&НаСервере
Процедура СформироватьДокументКонтракт()
	
	ДокументКонтрактОбъект = Документы.Контракт.СоздатьДокумент();
	ДокументКонтрактОбъект.Дата 				= ТекущаяДата();
	ДокументКонтрактОбъект.НомерКонтракта		= НомерКП;
	ДокументКонтрактОбъект.Вид 					= Перечисления.ВидыКонтрактов.КонтрактСПоставщиком;
	ДокументКонтрактОбъект.Тип 					= Перечисления.ТипыКонтрактов.КоммерческоеПредложение;
	ДокументКонтрактОбъект.Контрагент 			= ЗапросНаКоммерческоеПредложение.Поставщик;
	ДокументКонтрактОбъект.Валюта 				= ЗапросНаКоммерческоеПредложение.Валюта;
	ДокументКонтрактОбъект.Статус 				= Перечисления.СтатусыКонтрактов.Активен;
	ДокументКонтрактОбъект.ОтветственноеЛицо 	= Пользователи.ТекущийПользователь();
	
	Для Каждого СтрокаТЗПредметыСнабжения Из ТЗПредметыСнабжения Цикл
		
		НоваяСтрока = ДокументКонтрактОбъект.ПредметыСнабжения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗПредметыСнабжения);
		
		Если ЗначениеЗаполнено(НоваяСтрока.ПредметСнабжения) Тогда
			НоваяСтрока.ПредметСнабженияИсходный = НоваяСтрока.ПредметСнабжения;
		КонецЕсли;
		
		НоваяСтрока.СрокПоставки = СтрокаТЗПредметыСнабжения.СрокИзготовления;//?
		НоваяСтрока.Заявка 		 = Заявка;
		НайденныеСтроки 		 = Заявка.Спецификация.НайтиСтроки(Новый Структура("ПредметСнабжения, ЕдиницаИзмерения", НоваяСтрока.ПредметСнабжения, НоваяСтрока.ЕдиницаИзмерения)); 
		Если НайденныеСтроки.Количество() > 0 Тогда
			
			НоваяСтрока.ИдентификаторПозиции = НайденныеСтроки[0].ИдентификаторПозиции;
			
		КонецЕсли;

	КонецЦикла;
	
	Попытка 
		
		ДокументКонтрактОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Документ Коммерческое предложение №%1 от %2 успешно записан'"), СокрЛП(ДокументКонтрактОбъект.Номер), ДокументКонтрактОбъект.Дата); 				
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения); 
		
		КоммерческоеПредложение = ДокументКонтрактОбъект.Ссылка;
		Элементы.СоздатьКоммерческоеПредложение.Доступность = Ложь;
		
	Исключение
		
		ТекстОшибки = НСтр("ru = 'Не удалось записать документ коммерческого предложения!'"); 				
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		
	КонецПопытки;   

КонецПроцедуры //СформироватьДокументКонтракт

&НаСервере
Процедура СформироватьТабличнуюЧастьПредметыСнабженияНаСервере()
	
	ТЗ = РеквизитФормыВЗначение("ТЗПредметыСнабжения");
	ТЗ.Очистить();
	
	Для Каждого СтрокаТЗ Из ТаблицаПредметыСнабжения Цикл
		
		НоваяСтрока = ТЗ.Добавить();
		НоваяСтрока.НомерСтроки = ТЗ.Количество();
		НоваяСтрока.ПредметСнабжения = Справочники.КаталогПредметовСнабжения.НайтиПоРеквизиту("UID", СтрокаТЗ.Идентификатор);
		НоваяСтрока.ЕдиницаИзмерения = Справочники.ОКЕИ.НайтиПоНаименованию(СтрокаТЗ.ЕдиницаИзмерения);
		НоваяСтрока.Количество = СтрокаТЗ.Количество;
		НоваяСтрока.Цена = СтрокаТЗ.Цена;
		НоваяСтрока.СрокИзготовления = СтрокаТЗ.СрокИзготовления;
								
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТЗ, "ТЗПредметыСнабжения");
	
КонецПроцедуры //СформироватьТабличнуюЧастьПредметыСнабженияНаСервере





