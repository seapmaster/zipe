
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВыборДляПредметовСнабжения") Тогда
		
		Список.Отбор.Элементы.Очистить();
		
		НовЭлемент = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипИзмеряемойВеличины");
		НовЭлемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		НовЭлемент.ПравоеЗначение = Перечисления.ТипыИзмеряемыхВеличин.ЕдиницыВремени;
		НовЭлемент.Использование = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
