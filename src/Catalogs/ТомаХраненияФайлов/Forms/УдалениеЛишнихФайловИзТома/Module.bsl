#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ТомХраненияФайлов", ТомХраненияФайлов);
	
	ЗаполнитьТаблицуЛишнихФайлов();
	КоличествоЛишнихФайлов = ЛишниеФайлы.Количество();
	
	ПутьДня = Формат(ТекущаяДатаСеанса(), "ДФ=ггггММдд") + ПолучитьРазделительПути();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПодробнееНажатие(Элемент)
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыОтчета.Вставить("Отбор", Новый Структура("Том", ТомХраненияФайлов));
	
	ОткрытьФорму("Отчет.ПроверкаЦелостностиТома.ФормаОбъекта", ПараметрыОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКаталогаДляКопированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Каталог = ПутьКаталогаДляКопирования;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = Заголовок;
	
	ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ПутьКаталогаДляКопированияНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("ДиалогОткрытияФайла", ДиалогОткрытияФайла)));
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКаталогаДляКопированияНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	ДиалогОткрытияФайла = ДополнительныеПараметры.ДиалогОткрытияФайла;
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПутьКаталогаДляКопирования = ДиалогОткрытияФайла.Каталог;
		ПутьКаталогаДляКопирования = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКаталогаДляКопирования);
	КонецЕсли; // Если (ВыбранныеФайлы <> Неопределено) Тогда
КонецПроцедуры  // ПутьКаталогаДляКопированияНачалоВыбораЗавершение

&НаКлиенте
Процедура ПутьКаталогаДляКопированияПриИзменении(Элемент)
	
	ПутьКаталогаДляКопирования = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКаталогаДляКопирования);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьЛишниеФайлы(Команда)
	
	Если КоличествоЛишнихФайлов = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нет ни одного лишнего файла на диске'"));
		Возврат;
	КонецЕсли;
	
	Если Не ПравоЗаписиВКаталог() Тогда
		Возврат;
	КонецЕсли;
	
	МассивФайловСОшибками = Новый Массив;
	ЧислоУдаленныхФайлов = 0;
	
	КаталогДляКопирования = ПутьКаталогаДляКопирования + ПутьДня + ПолучитьРазделительПути();
	Для Каждого ЛишнийФайл Из ЛишниеФайлы Цикл
		Попытка
			Если Не ПустаяСтрока(ПутьКаталогаДляКопирования) Тогда
				ИмяФайлаСПутем = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьУникальноеИмяСПутем(
					КаталогДляКопирования,
					ЛишнийФайл.Имя);
				ПереместитьФайл(ЛишнийФайл.ПолноеИмя, КаталогДляКопирования + ИмяФайлаСПутем);
			Иначе
				УдалитьФайлы(ЛишнийФайл.ПолноеИмя);
			КонецЕсли;
			ЧислоУдаленныхФайлов = ЧислоУдаленныхФайлов + 1;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
		
			СтруктураОшибки = Новый Структура;
			СтруктураОшибки.Вставить("Имя", ЛишнийФайл.Имя);
			СтруктураОшибки.Вставить("Ошибка", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		
			МассивФайловСОшибками.Добавить(СтруктураОшибки);
			
			ОбработатьСообщениеОбОшибке(ЛишнийФайл.ПолноеИмя, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
		КонецПопытки;
	КонецЦикла;
	
	Если ЧислоУдаленныхФайлов <> 0 Тогда
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Удалено файлов: %1'"),
			ЧислоУдаленныхФайлов);
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Завершено удаление лишних файлов.'"),
			,
			ТекстОповещения,
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	Если МассивФайловСОшибками.Количество() > 0 Тогда
		ОтчетОбОшибках = Новый ТабличныйДокумент;
		СформироватьОтчетОбОшибках(ОтчетОбОшибках, МассивФайловСОшибками);
		ОтчетОбОшибках.Показать();
	КонецЕсли;
	
	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуЛишнихФайлов()
	
	ТаблицаФайловНаДиске = Новый ТаблицаЗначений;
	ТаблицаФайловНаДиске.Колонки.Добавить("Имя");
	ТаблицаФайловНаДиске.Колонки.Добавить("Файл");
	ТаблицаФайловНаДиске.Колонки.Добавить("ИмяБезРасширения");
	ТаблицаФайловНаДиске.Колонки.Добавить("ПолноеИмя");
	ТаблицаФайловНаДиске.Колонки.Добавить("Путь");
	ТаблицаФайловНаДиске.Колонки.Добавить("Том");
	ТаблицаФайловНаДиске.Колонки.Добавить("Расширение");
	ТаблицаФайловНаДиске.Колонки.Добавить("СтатусПроверки");
	ТаблицаФайловНаДиске.Колонки.Добавить("Количество");
	ТаблицаФайловНаДиске.Колонки.Добавить("Отредактировал");
	ТаблицаФайловНаДиске.Колонки.Добавить("ДатаРедактирования");

	ПутьКТому = ФайловыеФункцииСлужебный.ПолныйПутьТома(ТомХраненияФайлов);
	
	МассивФайлов = НайтиФайлы(ПутьКТому,"*", Истина);
	Для Каждого Файл Из МассивФайлов Цикл
		
		Если Не Файл.ЭтоФайл() Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаФайловНаДиске.Добавить();
		НоваяСтрока.Имя = Файл.Имя;
		НоваяСтрока.ИмяБезРасширения = Файл.ИмяБезРасширения;
		НоваяСтрока.ПолноеИмя = Файл.ПолноеИмя;
		НоваяСтрока.Путь = Файл.Путь;
		НоваяСтрока.Расширение = Файл.Расширение;
		НоваяСтрока.СтатусПроверки = НСтр("ru = 'Лишние файлы (есть на диске, но сведения о них отсутствуют)'");
		НоваяСтрока.Количество = 1;
		НоваяСтрока.Том = ТомХраненияФайлов;
	КонецЦикла;
	
	ФайловыеФункцииСлужебный.ПроверитьЦелостностьФайлов(ТаблицаФайловНаДиске, ТомХраненияФайлов);
	МассивЛишнихФайлов = ТаблицаФайловНаДиске.НайтиСтроки(
		Новый Структура("СтатусПроверки", НСтр("ru = 'Лишние файлы (есть на диске, но сведения о них отсутствуют)'")));
	
	Для Каждого Файл Из МассивЛишнихФайлов Цикл
		НоваяСтрока = ЛишниеФайлы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Файл);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПравоЗаписиВКаталог()
	
	Если Не ПустаяСтрока(ПутьКаталогаДляКопирования) Тогда
		
		ИмяКаталогаТестовое = ПутьКаталогаДляКопирования + "ПроверкаДоступа\";
		
		Попытка
			СоздатьКаталог(ИмяКаталогаТестовое);
			УдалитьФайлы(ИмяКаталогаТестовое);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			
			ШаблонОшибки =
				НСтр("ru = 'Путь каталога для копирования некорректен.
					|Возможно учетная запись, от лица которой работает
					|сервер 1С:Предприятия, не имеет прав доступа к указанному каталогу.
					|
					|%1'");
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонОшибки, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки, , , "ПутьКаталогаДляКопирования");
			
			Возврат Ложь;
			
		КонецПопытки;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбработатьСообщениеОбОшибке(ИмяФайла, ИнформацияОбОшибке)
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Файлы.Ошибка удаления лишних файлов'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,,,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При удалении файла с диска
				|""%1""
				|возникла ошибка:
				|""%2"".'"),
			ИмяФайла,
			ИнформацияОбОшибке));
		
	КонецПроцедуры

&НаСервере
Процедура СформироватьОтчетОбОшибках(ОтчетОбОшибках, МассивФайловСОшибками)
	
	ТабМакет = Справочники.ТомаХраненияФайлов.ПолучитьМакет("МакетОтчета");
	
	ОбластьЗаголовок = ТабМакет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок.Параметры.Описание = НСтр("ru = 'Файлы с ошибками:'");
	ОтчетОбОшибках.Вывести(ОбластьЗаголовок);
	
	ОбластьСтрока = ТабМакет.ПолучитьОбласть("Строка");
	
	Для Каждого ФайлСОшибкой Из МассивФайловСОшибками Цикл
		ОбластьСтрока.Параметры.Название = ФайлСОшибкой.Имя;
		ОбластьСтрока.Параметры.Ошибка = ФайлСОшибкой.Ошибка;
		ОтчетОбОшибках.Вывести(ОбластьСтрока);
	КонецЦикла;

	
КонецПроцедуры

#КонецОбласти