////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьЗаказыПоЗаказчику(Заказчик, СтрокаПоиска = "") Экспорт
	Запрос 			= Новый Запрос;
	Запрос.Текст 	= "ВЫБРАТЬ
	             	  |	Заказы.Ссылка КАК Ссылка
	             	  |ИЗ
	             	  |	Справочник.Заказы КАК Заказы
	             	  |ГДЕ
	             	  |	НЕ Заказы.ПометкаУдаления
	             	  |	И Заказы.Заказчик = &Заказчик";
	Если ТипЗнч(Заказчик) = Тип("СправочникСсылка.Флоты") Тогда
		Запрос.УстановитьПараметр("Заказчик", Заказчик);
	ИначеЕсли ТипЗнч(Заказчик) = Тип("СправочникСсылка.ИностранныеЗаказчики") Тогда
		Запрос.УстановитьПараметр("Заказчик", Заказчик.ВМС);
	Иначе
		Запрос.УстановитьПараметр("Заказчик", Неопределено);
	КонецЕсли; // Если ТипЗнч(Заказчик) = Тип("СправочникСсылка.Флоты") Тогда
	
	Если Не СтрокаПоиска = "" Тогда
		Запрос.Текст = Запрос.Текст + " И Заказы.Наименование Подобно &Наименование";
		Запрос.УстановитьПараметр("Наименование", СтрокаПоиска + "%");
	КонецЕсли; // Если Не СтрокаПоиска = "" Тогда
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции // ПолучитьЗаказыПоЗаказчику

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не Параметры.Отбор.Свойство("Заказчик") Тогда
		Возврат;
	КонецЕсли; // Если Не Параметры.Отбор.Свойство("Заказчик") Тогда
	
	СтандартнаяОбработка 	= Ложь;
	ДанныеВыбора 			= Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(ПолучитьЗаказыПоЗаказчику(Параметры.Отбор.Заказчик, Параметры.СтрокаПоиска));
КонецПроцедуры // ОбработкаПолученияДанныхВыбора
