&НаСервере
Процедура ВывестиИзображенияНаСервере()
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	Справочник.ПроектыКораблейПрисоединенныеФайлы КАК ПрисоединенныеФайлы
	|ГДЕ
	|	ПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Объект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ЭтаФорма.АдресКартинки = ПрисоединенныеФайлы.ПолучитьДанныеФайла(Выборка.Ссылка).СсылкаНаДвоичныеДанныеФайла;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВывестиИзображения()
	ВывестиИзображенияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ВывестиИзображения",0.1,Истина);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыДляКорректировкиСправочников") И КоманднаяПанель.ПодчиненныеЭлементы.ФормаОбщаяКомандаАкцептоватьИзмененияВСправочнике.Видимость Тогда
	
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если СлужебныеФункции.НайтиДубльСправочникаПоНаименованию(ТекущийОбъект.Ссылка, ТекущийОбъект.Наименование) Тогда
		
		Сообщить("В справочнике уже есть элемент с таким номером проекта!", СтатусСообщения.Важное);
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереводНаименования(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		ПоказатьПредупреждение(, "Для работы с переводом необходимо записать объект",, "Действие запрещено");
		Возврат;
	
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("Владелец", Объект.Ссылка);
	ПараметрыОткрытия.Вставить("ИмяРеквизита", "Наименование");
	ПараметрыОткрытия.Вставить("Значение", Объект.Наименование);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработчикПереводаНаименования", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.Перевод", ПараметрыОткрытия, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикПереводаНаименования(ВозЗнач, ДопПараметры = Неопределено) Экспорт

	ПроверитьПереводы("Наименование");		

КонецПроцедуры

&НаСервере
Процедура ПроверитьПереводы(ИмяРеквизита = Неопределено)
	
	Если ИмяРеквизита = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ДополнительныеНаименования.ИмяРеквизита,
		|	ДополнительныеНаименования.Язык
		|ИЗ
		|	РегистрСведений.ДополнительныеНаименования КАК ДополнительныеНаименования
		|ГДЕ
		|	ДополнительныеНаименования.Владелец = &Владелец";
		
		Запрос.УстановитьПараметр("Владелец", Объект.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			
			Возврат;	
			
		КонецЕсли;
		
		МассивПереводовНаименований = Новый Массив;
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ИмяРеквизита = "Наименование" Тогда
				
				МассивПереводовНаименований.Добавить(Выборка.Язык);	
				
			КонецЕсли;	
			
		КонецЦикла;
		
		Если МассивПереводовНаименований.Количество() > 0 Тогда
			
			МассивПереводовНаименований.Вставить(0, "Есть перевод на языки:");
			
			Команды.ПереводНаименования.Подсказка = СтрСоединить(МассивПереводовНаименований, Символы.ПС);
			
		КонецЕсли;
				
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	ДополнительныеНаименования.Язык
		|ИЗ
		|	РегистрСведений.ДополнительныеНаименования КАК ДополнительныеНаименования
		|ГДЕ
		|	ДополнительныеНаименования.Владелец = &Владелец
		|	И ДополнительныеНаименования.ИмяРеквизита = &ИмяРеквизита";
		
		Запрос.УстановитьПараметр("Владелец", Объект.Ссылка);
		Запрос.УстановитьПараметр("ИмяРеквизита", ИмяРеквизита);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			
			Если ИмяРеквизита = "Наименование" Тогда
				
				Команды.ПереводНаименования.Подсказка = "Нет переводов";	
				
			КонецЕсли;
			
			Возврат;
			
		КонецЕсли;
		
		МассивПереводов = Новый Массив;
		
		МассивПереводов.Добавить("Есть перевод на языки:");
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			МассивПереводов.Добавить(Выборка.Язык);	
							
		КонецЦикла;
		
		Если ИмяРеквизита = "Наименование" Тогда
		
			Команды.ПереводНаименования.Подсказка = СтрСоединить(МассивПереводов, Символы.ПС);	
		
		КонецЕсли;	
		
	КонецЕсли;	

КонецПроцедуры // ПроверитьПереводы()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПроверитьПереводы();
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма);
	
КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма);
	
КонецПроцедуры

