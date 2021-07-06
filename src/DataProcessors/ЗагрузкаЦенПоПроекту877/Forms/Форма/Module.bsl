//ПРОЦЕДУРЫ И ФУНКЦИИ ЗАГРУЗКИ ДАННЫХ
#Область ЗагрузкаДанных

&НаКлиенте
Процедура ЗагрузитьЦены(Команда)
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗагрузитьЦеныЗавершение", ЭтаФорма), "Данные таблицы цен будут обновлены. Продолжить?",РежимДиалогаВопрос.ДаНет);  
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЦеныЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Цены.Очистить();
		СоответствиеЗаказов = ПолучитьСоответствиеЗаказов();
		ДатаНачала = ТекущаяДата();
		НачатьПоискФайлов(Новый ОписаниеОповещения("ЗагрузитьЦеныЗавершениеЗавершение", ЭтотОбъект, Новый Структура("ДатаНачала, СоответствиеЗаказов", ДатаНачала, СоответствиеЗаказов)), ПутьКФайлам,"*.xls",Истина);
		
	Иначе
		Сообщить("Прервано пользователем!");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЦеныЗавершениеЗавершение(НайденныеФайлы, ДополнительныеПараметры1) Экспорт
	
	ДатаНачала = ДополнительныеПараметры1.ДатаНачала;
	СоответствиеЗаказов = ДополнительныеПараметры1.СоответствиеЗаказов;
	
	МассивФайлов = НайденныеФайлы;
	
	Сч = 1;
	ВсегоФайлов = МассивФайлов.Количество();
	
	Для каждого Файл Из МассивФайлов Цикл
		
		Если Найти(Файл.Имя,"~") > 0 Тогда
			Продолжить;
		КонецЕсли; 
		
		УправлениеИнтерфейсом.ВывестиТекущееСостояние("Загрузка цен из файлов",ДатаНачала,Сч,ВсегоФайлов);
		
		ПрочитатьФайлЦен(Файл,СоответствиеЗаказов);
		
		Сч = Сч+1;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайлЦен(Файл,СоответствиеЗаказов)
	
	СтрокаПодключения = "Provider=MSDASQL.1;Persist Security Info=False;Extended Properties=""DSN=Excel Files;DBQ=&Filename;DriverId=1046;MaxBufferSize=2048;PageTimeout=5;""";
	СтрокаПодключения = СтрЗаменить(СтрокаПодключения,"&Filename",Файл.ПолноеИмя);
	
	Соединение = Новый COMОбъект("ADODB.CONNECTION");
	
	Попытка
		Соединение.Open(СтрокаПодключения);
	Исключение
		ТекИнформацияОбОшибке = "Произошла ошибка: " + ОписаниеОшибки() + ", не подключиться к источнику. Обработка прервана!";
		Сообщить(ТекИнформацияОбОшибке,СтатусСообщения.Важное);
		Возврат;
	КонецПопытки;
	
	БД = Новый COMОбъект("ADOX.Catalog");
	БД.ActiveConnection = Соединение;
	
	ИмяТаблицы = Неопределено;
	
	ТаблицыБД = БД.Tables;
	Для каждого ТаблицаБД из ТаблицыБД Цикл 
		ИмяТаблицы = ТаблицаБД.Name;
		Прервать;
	КонецЦикла;
	
	ТекстЗапроса =
	"select *
    |from [&ИмяТаблицы]
    |where F10 <> ''";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ИмяТаблицы",ИмяТаблицы);
	
	НаборЗаписей = Новый COMОбъект("ADODB.RecordSet");
	
	Попытка
		НаборЗаписей.CursorType = 3;
		НаборЗаписей.Open(ТекстЗапроса,Соединение);
	Исключение
		ТекИнформацияОбОшибке = "Не получены данные таблицы файла по причине "+ОписаниеОшибки();
		Сообщить(ТекИнформацияОбОшибке,СтатусСообщения.Важное);
		Возврат;
	КонецПопытки;
	
	Пока НаборЗаписей.EOF()=0 Цикл
		
		Цена = ПолучитьЗначениеВЯчейке(НаборЗаписей,9,Истина);
		
		Если Найти(Цена,"ЦЕНА") > 0 Тогда
			НаборЗаписей.MoveNext();
			Продолжить;
		КонецЕсли;
		
		Если Найти(Цена,"PRICE") > 0 Тогда
			ЗаводскойНомер = Лев(Прав(Файл.Путь,6),5);
			ДатаЦены = ПолучитьДатуЦены(Цена);
			НаборЗаписей.MoveNext();
			Продолжить;
		КонецЕсли;
		
		Количество = ПолучитьЗначениеВЯчейке(НаборЗаписей,8,Истина);
		
		Обозначение =  ПолучитьЗначениеВЯчейке(НаборЗаписей,2,Истина);
		Наименование = ПолучитьЗначениеВЯчейке(НаборЗаписей,3);
		
		СтрокаЦен = Цены.Добавить();
		СтрокаЦен.Файл = Файл.ПолноеИмя;
		СтрокаЦен.Заказ = СоответствиеЗаказов.Получить(ЗаводскойНомер);
		СтрокаЦен.Наименование = Наименование;
		СтрокаЦен.Обозначение = Обозначение;
		СтрокаЦен.Количество = Число(Количество);
		СтрокаЦен.Цена = Число(Цена);
		СтрокаЦен.ДатаЦены = ДатаЦены;
		
		НаборЗаписей.MoveNext();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗначениеВЯчейке(НаборЗаписей,НомерКолонки,ПреобразоватьВСтроку=Ложь)
		
	ЗначениеВЯчейке = НаборЗаписей.Fields(НомерКолонки).Value;
	
	Если ТипЗнч(ЗначениеВЯчейке) = Тип("Число") И ПреобразоватьВСтроку Тогда
		ЗначениеВЯчейке = Формат(ЗначениеВЯчейке,"ЧГ=0");
	КонецЕсли;
	
	Если ТипЗнч(ЗначениеВЯчейке) = Тип("Строка") И Найти(ЗначениеВЯчейке,Символы.ПС) > 0 Тогда
		ЗначениеВЯчейке = СтрЗаменить(ЗначениеВЯчейке,Символы.ПС," ");
	КонецЕсли;
	
	Если ТипЗнч(ЗначениеВЯчейке) = Тип("Строка") Тогда
		ЗначениеВЯчейке = СтрЗаменить(ЗначениеВЯчейке,"     "," ");
		ЗначениеВЯчейке = СтрЗаменить(ЗначениеВЯчейке,"    "," ");
		ЗначениеВЯчейке = СтрЗаменить(ЗначениеВЯчейке,"   "," ");	
		ЗначениеВЯчейке = СтрЗаменить(ЗначениеВЯчейке,"  "," ");	
	КонецЕсли; 
	
	Возврат СокрЛП(ЗначениеВЯчейке);
		
КонецФункции

&НаКлиенте
Функция ПолучитьДатуЦены(Цена)
	
	ЦенаБезПробелов = СтрЗаменить(Цена," ","");
	ГодЦены = Сред(ЦенаБезПробелов,6,4);
	ДатаЦены = Дата(ГодЦены+"1231235959");
	
	Возврат ДатаЦены;
	
КонецФункции

&НаСервере
Функция ПолучитьСоответствиеЗаказов()
	
	СоответствиеЗаказов = Новый Соответствие;
	СоответствиеЗаказов.Вставить("01313",Справочники.Заказы.НайтиПоРеквизиту("ЗаводскойНомер","01313/0831"));
	СоответствиеЗаказов.Вставить("01325",Справочники.Заказы.НайтиПоРеквизиту("ЗаводскойНомер","01325/0132"));
	
	Возврат СоответствиеЗаказов;
	
КонецФункции

#КонецОбласти

//ПРОЦЕДУРЫ И ФУНКЦИИ ЗАПИСИ ДАННЫХ
#Область ЗаписьДанных

&НаКлиенте
Процедура ЗаписатьЦены(Команда)
	
	Если Цены.Количество() = 0 Тогда
		
		Сообщить("Таблица цен пуста!");
		Возврат;
		
	КонецЕсли; 
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаписатьЦеныЗавершение", ЭтаФорма), "Данные в базе данных будут изменены. Продолжить?",РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЦеныЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ПроизвестиЗаписьЦен();
		
	Иначе
		
		Сообщить("Прервано пользователем!");
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПроизвестиЗаписьЦен()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Цены.Заказ,
	|	Цены.Наименование,
	|	Цены.Обозначение,
	|	Цены.Цена,
	|	Цены.ДатаЦены,
	|	Цены.Количество
	|ПОМЕСТИТЬ втЦены
	|ИЗ
	|	&Цены КАК Цены
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втЦены.Заказ,
	|	втЦены.Наименование,
	|	втЦены.Обозначение,
	|	ЕСТЬNULL(СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ПредметСнабжения, ЗНАЧЕНИЕ(Справочник.КаталогПредметовСнабжения.ПустаяСсылка)) КАК ПредметСнабжения,
	|	втЦены.Цена,
	|	втЦены.ДатаЦены,
	|	втЦены.Количество КАК Количество
	|ПОМЕСТИТЬ втЦеныПС
	|ИЗ
	|	втЦены КАК втЦены
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураЗаказаПоКомплектующимИзделиямИЗИП КАК СтруктураЗаказаПоКомплектующимИзделиямИЗИП
	|		ПО втЦены.Заказ = СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Владелец
	|			И втЦены.Наименование = СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Наименование
	|			И втЦены.Обозначение = СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ОбозначениеДоп
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПредметСнабжения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втЦеныПС.Заказ КАК Заказ,
	|	втЦеныПС.Наименование,
	|	втЦеныПС.Обозначение КАК Обозначение,
	|	втЦеныПС.Цена,
	|	втЦеныПС.ДатаЦены,
	|	втЦеныПС.Количество
	|ПОМЕСТИТЬ втПустыеПС
	|ИЗ
	|	втЦеныПС КАК втЦеныПС
	|ГДЕ
	|	втЦеныПС.ПредметСнабжения = ЗНАЧЕНИЕ(Справочник.КаталогПредметовСнабжения.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Заказ,
	|	Обозначение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втЦеныПС.Заказ,
	|	втЦеныПС.ПредметСнабжения,
	|	втЦеныПС.Цена,
	|	втЦеныПС.ДатаЦены,
	|	втЦеныПС.Количество
	|ПОМЕСТИТЬ втЦеныПредметовСнабжения
	|ИЗ
	|	втЦеныПС КАК втЦеныПС
	|ГДЕ
	|	НЕ втЦеныПС.ПредметСнабжения = ЗНАЧЕНИЕ(Справочник.КаталогПредметовСнабжения.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втПустыеПС.Заказ,
	|	ЕСТЬNULL(СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ПредметСнабжения, ЗНАЧЕНИЕ(Справочник.КаталогПредметовСнабжения.ПустаяСсылка)),
	|	втПустыеПС.Цена,
	|	втПустыеПС.ДатаЦены,
	|	втПустыеПС.Количество
	|ИЗ
	|	втПустыеПС КАК втПустыеПС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтруктураЗаказаПоКомплектующимИзделиямИЗИП КАК СтруктураЗаказаПоКомплектующимИзделиямИЗИП
	|		ПО втПустыеПС.Заказ = СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Владелец
	|			И втПустыеПС.Обозначение = СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ОбозначениеДоп
	|			И (НЕ втПустыеПС.Обозначение = """")
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втЦеныПредметовСнабжения.ДатаЦены КАК ДатаЦены,
	|	втЦеныПредметовСнабжения.ПредметСнабжения КАК ПредметСнабжения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЦен.Внешняя) КАК ТипЦены,
	|	&Контрагент,
	|	втЦеныПредметовСнабжения.Цена КАК Цена,
	|	МИНИМУМ(втЦеныПредметовСнабжения.Количество) КАК Количество,
	|	&Валюта,
	|	КаталогПредметовСнабжения.ЕдиницаИзмерения,
	|	ЗНАЧЕНИЕ(Перечисление.СтатусыКонтрактов.Активен) КАК Статус,
	|	втЦеныПредметовСнабжения.Заказ КАК Заказ
	|ПОМЕСТИТЬ втРезультатБезНумерации
	|ИЗ
	|	втЦеныПредметовСнабжения КАК втЦеныПредметовСнабжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КаталогПредметовСнабжения КАК КаталогПредметовСнабжения
	|		ПО втЦеныПредметовСнабжения.ПредметСнабжения = КаталогПредметовСнабжения.Ссылка,
	|	Справочник.ИностранныеЗаказчики КАК ИностранныеЗаказчики
	|
	|СГРУППИРОВАТЬ ПО
	|	КаталогПредметовСнабжения.ЕдиницаИзмерения,
	|	втЦеныПредметовСнабжения.Заказ,
	|	втЦеныПредметовСнабжения.Цена,
	|	втЦеныПредметовСнабжения.ДатаЦены,
	|	втЦеныПредметовСнабжения.ПредметСнабжения
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДатаЦены,
	|	Заказ,
	|	ПредметСнабжения,
	|	Цена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втРезультатБезНумерации.ДатаЦены КАК ДатаЦены,
	|	втРезультатБезНумерации.ПредметСнабжения КАК ПредметСнабжения,
	|	втРезультатБезНумерации.ТипЦены,
	|	втРезультатБезНумерации.Контрагент,
	|	втРезультатБезНумерации.Цена,
	|	втРезультатБезНумерации.Количество,
	|	втРезультатБезНумерации.Валюта,
	|	втРезультатБезНумерации.ЕдиницаИзмерения,
	|	втРезультатБезНумерации.Статус,
	|	втРезультатБезНумерации.Заказ КАК Заказ,
	|	КОЛИЧЕСТВО(Порядок.Цена) КАК ПорядковыйНомер
	|ПОМЕСТИТЬ втРезультатСНумерацией
	|ИЗ
	|	втРезультатБезНумерации КАК втРезультатБезНумерации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втРезультатБезНумерации КАК Порядок
	|		ПО втРезультатБезНумерации.ДатаЦены = Порядок.ДатаЦены
	|			И втРезультатБезНумерации.Заказ = Порядок.Заказ
	|			И втРезультатБезНумерации.ПредметСнабжения = Порядок.ПредметСнабжения
	|			И втРезультатБезНумерации.Цена >= Порядок.Цена
	|
	|СГРУППИРОВАТЬ ПО
	|	втРезультатБезНумерации.Заказ,
	|	втРезультатБезНумерации.Статус,
	|	втРезультатБезНумерации.ЕдиницаИзмерения,
	|	втРезультатБезНумерации.Валюта,
	|	втРезультатБезНумерации.ДатаЦены,
	|	втРезультатБезНумерации.ТипЦены,
	|	втРезультатБезНумерации.ПредметСнабжения,
	|	втРезультатБезНумерации.Контрагент,
	|	втРезультатБезНумерации.Цена,
	|	втРезультатБезНумерации.Количество
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втРезультатСНумерацией.ДатаЦены КАК ДатаЦены,
	|	втРезультатСНумерацией.ПредметСнабжения,
	|	втРезультатСНумерацией.ТипЦены,
	|	втРезультатСНумерацией.Контрагент,
	|	втРезультатСНумерацией.Цена,
	|	втРезультатСНумерацией.Количество,
	|	втРезультатСНумерацией.Валюта,
	|	втРезультатСНумерацией.ЕдиницаИзмерения,
	|	втРезультатСНумерацией.Статус,
	|	втРезультатСНумерацией.Заказ КАК Заказ,
	|	втРезультатСНумерацией.ПорядковыйНомер КАК ПорядковыйНомер
	|ИЗ
	|	втРезультатСНумерацией КАК втРезультатСНумерацией
	|ИТОГИ ПО
	|	ДатаЦены,
	|	Заказ,
	|	ПорядковыйНомер";
	Запрос.УстановитьПараметр("Цены",РеквизитФормыВЗначение("Цены",Тип("ТаблицаЗначений")));
	Запрос.УстановитьПараметр("Контрагент",Справочники.ИностранныеЗаказчики.НайтиПоНаименованию("Индия"));
	Запрос.УстановитьПараметр("Валюта",Справочники.ОКВ.НайтиПоНаименованию("USD"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Сообщить("Предметы снабжения не найдены!");
		Возврат;
	КонецЕсли;
	
	ДеревоЗапроса = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Для каждого СтрокаДата Из ДеревоЗапроса.Строки Цикл
		
		Для каждого СтрокаЗаказ Из СтрокаДата.Строки Цикл
			
			Для каждого СтрокаПорядок Из СтрокаЗаказ.Строки Цикл
				
				ВводНачальныхОстатковЦен = Документы.ВводНачальныхОстатковЦен.СоздатьДокумент();
				ВводНачальныхОстатковЦен.Дата = СтрокаДата.ДатаЦены;
				ВводНачальныхОстатковЦен.Комментарий = "Цены по проекту 877ЭКМ. Загружены "+Строка(ТекущаяДата());
				
				Для каждого СтрокаЦены Из СтрокаПорядок.Строки Цикл
					
					СтрокаТабличнойЧасти = ВводНачальныхОстатковЦен.Цены.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти,СтрокаЦены);
					
				КонецЦикла;
				
				ВводНачальныхОстатковЦен.Записать(РежимЗаписиДокумента.Проведение);
				Сообщить("Создан документ "+Строка(ВводНачальныхОстатковЦен.Ссылка)+" по заказу "+Строка(СтрокаЦены.Заказ));
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти


//ПРОЦЕДУРЫ И ФУНКЦИИ СОБЫТИЙ ФОРМЫ
#Область СобытияФормы
  
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПутьКФайлам = "W:\КТ\зип-Э\Звездочка\ЗИП\";
	
	Проект = Справочники.ПроектыКораблей.НайтиПоНаименованию("877ЭКМ");
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайламНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	
	ВыборФайла.Показать(Новый ОписаниеОповещения("ПутьКФайламНачалоВыбораЗавершение", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайламНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПутьКФайлам = ВыбранныеФайлы[0];
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьТаблицу(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяТаблицы","Цены");
	ДополнительныеПараметры.Вставить("ЭтоСохранение",Ложь);
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ВыполнитьДействиеСохраненияЗагрузкиТаблицы", ЭтаФорма,ДополнительныеПараметры), "Загрузить таблицу цен?",РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьТаблицу(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяТаблицы","Цены");
	ДополнительныеПараметры.Вставить("ЭтоСохранение",Истина);
	
	Если Цены.Количество() = 0 Тогда
		Сообщить("Нет данных для сохранения!");
		Возврат;
	Иначе
		ПоказатьВопрос(Новый ОписаниеОповещения("ВыполнитьДействиеСохраненияЗагрузкиТаблицы", ЭтаФорма,ДополнительныеПараметры), "Сохранить таблицу цен?",РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеСохраненияЗагрузкиТаблицы(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Сообщить("Прервано пользователем!");
		Возврат;
	КонецЕсли;
	
	Текст = Новый ТекстовыйДокумент;
	ПолноеИмяФайла = КаталогВременныхФайлов+ДополнительныеПараметры.ИмяТаблицы+".xml";
	
	Если ДополнительныеПараметры.ЭтоСохранение Тогда
		Сообщить("Сохранение таблицы начато в "+ТекущаяДата());
		СтрокаXML = СериализоватьТаблицуВXML(ДополнительныеПараметры.ИмяТаблицы);
		Текст.ДобавитьСтроку(СтрокаXML);
		Текст.Записать(ПолноеИмяФайла);
		Сообщить("Файл "+ПолноеИмяФайла+" сохранен в "+ТекущаяДата());
	Иначе //это загрузка
		Сообщить("Загрузка таблицы начата в "+ТекущаяДата());
		Попытка
			Текст.Прочитать(ПолноеИмяФайла);
			СтрокаXML = Текст.ПолучитьТекст();
			ПолучитьТаблицуИзXML(СтрокаXML,ДополнительныеПараметры.ИмяТаблицы);
			Сообщить("Загрузка таблицы окончена в "+ТекущаяДата());
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

//функция возвращает строку, содеражащую сериализованную в XML таблицу
&НаСервере
Функция СериализоватьТаблицуВXML(ИмяТаблицы)
	
	Сериализатор = Новый СериализаторXDTO(ФабрикаXDTO);
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	
	ТаблицаЗначений = РеквизитФормыВЗначение(ИмяТаблицы,Тип("ТаблицаЗначений")); 
	Сериализатор.ЗаписатьXML(ЗаписьXML,ТаблицаЗначений);
	       
	СтрокаXML = ЗаписьXML.Закрыть();
	
	Возврат СтрокаXML;
	
КонецФункции

//процедура загружает таблицу из строки, содержащей текст XML
&НаСервере
Процедура ПолучитьТаблицуИзXML(СтрокаXML,ИмяТаблицы)
	
	Сериализатор = Новый СериализаторXDTO(ФабрикаXDTO);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	ТаблицаЗначений = Сериализатор.ПрочитатьXML(ЧтениеXML,Тип("ТаблицаЗначений"));
	ЗначениеВРеквизитФормы(ТаблицаЗначений,ИмяТаблицы);
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НачатьПолучениеКаталогаВременныхФайлов(Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект)); 
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(ИмяКаталогаВременныхФайлов, ДополнительныеПараметры) Экспорт
	
	КаталогВременныхФайлов = ИмяКаталогаВременныхФайлов;
	Если Не Прав(КаталогВременныхФайлов,1) = "\" Тогда
		КаталогВременныхФайлов = КаталогВременныхФайлов + "\";
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
