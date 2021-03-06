////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ИзменитьСписок(Знач Проекты)

	Список.ПроизвольныйЗапрос = Истина;
	
	Список.ТекстЗапроса = "ВЫБРАТЬ
	|	СправочникЗаказы.Ссылка,
	|	СправочникЗаказы.ПометкаУдаления,
	|	СправочникЗаказы.Владелец,
	|	СправочникЗаказы.Код,
	|	СправочникЗаказы.Наименование,
	|	СправочникЗаказы.БортовойНомер,
	|	СправочникЗаказы.Заказчик,
	|	СправочникЗаказы.ДатаПостройки,
	|	СправочникЗаказы.Строитель,
	|	СправочникЗаказы.ЗаводскойНомер,
	|	СправочникЗаказы.ДополнительнаяИнформация,
	|	СправочникЗаказы.Предопределенный,
	|	СправочникЗаказы.ИмяПредопределенныхДанных
	|ИЗ
	|	Справочник.Заказы КАК СправочникЗаказы
	|ГДЕ
	|	СправочникЗаказы.Владелец В(&Проекты)";
	
	Список.Параметры.УстановитьЗначениеПараметра("Проекты", Проекты);	

КонецПроцедуры // ИзменитьСписок()

&НаСервере
Процедура УстановитьОтборПоЗаказчику()
	Список.Отбор.Элементы.Очистить();
	ЭлементОтбора 					= Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Заказчик");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение 	= Заказчик.ВМС;
	ЭлементОтбора.Использование 	= Истина;
КонецПроцедуры // УстановитьОтборПоЗаказчику

////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТипЗнч(ВладелецФормы) = Тип("ТаблицаФормы") Тогда
	
		Если ВладелецФормы.ТекущийЭлемент.ПараметрыВыбора.Количество() > 0 Тогда
			
			Для каждого ПараметрВыбора Из ВладелецФормы.ТекущийЭлемент.ПараметрыВыбора Цикл
			
				Если ПараметрВыбора.Имя = "Проекты" Тогда
					
					Если ПараметрВыбора.Значение.Количество() > 0 Тогда
					
						ИзменитьСписок(ПараметрВыбора.Значение);	
					
					КонецЕсли;
					
					Прервать;
					
				КонецЕсли;	
				
			КонецЦикла;
			
		КонецЕсли;	
	
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//++ 29.06.2018 Веденеев П. //отключение видимости служебного корабля в списке
	ОтборСлужебныйЗаказ = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборСлужебныйЗаказ.Использование = Истина;
	ОтборСлужебныйЗаказ.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
	ОтборСлужебныйЗаказ.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборСлужебныйЗаказ.ПравоеЗначение = Константы.СлужебныйЗаказ.Получить();
	//++ 29.06.2018 Веденеев П. //отключение видимости служебного корабля в списке
	
	Параметры.Свойство("Заказчик", Заказчик);
	Если ЗначениеЗаполнено(Заказчик) Тогда
		УстановитьОтборПоЗаказчику();
	КонецЕсли; // Если ЗначениеЗаполнено(Заказчик) Тогда	
КонецПроцедуры

