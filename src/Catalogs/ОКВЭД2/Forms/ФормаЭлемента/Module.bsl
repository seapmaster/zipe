
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыДляКорректировкиСправочников") И КоманднаяПанель.ПодчиненныеЭлементы.ФормаОбщаяКомандаАкцептоватьИзмененияВСправочнике.Видимость Тогда
	
		Отказ = Истина;
		Возврат;
	
	КонецЕсли;
	
	Если СлужебныеФункции.НайтиДубльСправочникаПоНаименованию(ТекущийОбъект.Ссылка, ТекущийОбъект.Наименование) Тогда
		
		Сообщить("В справочнике уже есть элемент с таким наименованием!", СтатусСообщения.Важное);
		Отказ = Истина;
		Возврат;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма);
	
КонецПроцедуры
