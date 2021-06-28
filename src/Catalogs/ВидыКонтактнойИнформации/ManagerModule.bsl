#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//  Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//           где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы,
//           связанного с реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Тип;Тип");
	БлокируемыеРеквизиты.Добавить("Родитель");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("*");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиОбновления

// Регистрирует к обработке виды контактной информации другое у которых необходимо заполнить поле ВидПоляДругое.
//
Процедура ЗаполнитьВидыКонтактнойИнформацииСПолемДругоеКОбработке(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Ссылка,
		|	ВидыКонтактнойИнформации.УдалитьМногострочноеПоле
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|ГДЕ
		|	ВидыКонтактнойИнформации.Тип = &Тип";
	
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.Другое);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();

	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры,
		РезультатЗапроса.ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры
	
Процедура ОбновитьВидПоляДругое(Параметры) Экспорт
	
	ВидКонтактнойИнформацииСсылка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ВидыКонтактнойИнформации");
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Пока ВидКонтактнойИнформацииСсылка.Следующий() Цикл
		Попытка
			ВидКонтактнойИнформации = ВидКонтактнойИнформацииСсылка.Ссылка.ПолучитьОбъект();
			Если ВидКонтактнойИнформации.УдалитьМногострочноеПоле Тогда
				ВидКонтактнойИнформации.ВидПоляДругое = "МногострочноеШирокое";
			Иначе
				ВидКонтактнойИнформации.ВидПоляДругое = "ОднострочноеШирокое";
			КонецЕсли;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ВидКонтактнойИнформации);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			// Если не удалось обработать какой-либо вид контактной информации, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать вид контактной информации: %1 по причине: %2'"),
					ВидКонтактнойИнформацииСсылка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.ВидыКонтактнойИнформации, ВидКонтактнойИнформацииСсылка.Ссылка, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.ВидыКонтактнойИнформации");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре ОбновитьВидПоляДругое не удалось обработать некоторые виды контактной информации (пропущены): %1'"), 
				ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.ВидыКонтактнойИнформации,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Процедура ОбновитьВидПоляДругое обработала очередную порцию видов контактной информации: %1'"),
					ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

