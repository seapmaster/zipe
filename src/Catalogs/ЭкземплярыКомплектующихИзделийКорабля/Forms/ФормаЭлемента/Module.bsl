
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		Объект.Наименование = Строка(Объект.Владелец);
		
		ПроверитьПревышениеКоличества();
		
		// ++ 02.07.2018 15:03:46 Базунов Д.А. Задача: 
		// Перенес сюда, т.к. при создании нового не работает отбор по помещениям
		Объект.Корабль = Объект.Владелец.Владелец;
		// -- 02.07.2018 15:03:46 Базунов Д.А. Задача:
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьПревышениеКоличества()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЭкземплярыКомплектующихИзделийКорабля.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЭкземплярыКомплектующихИзделийКорабля КАК ЭкземплярыКомплектующихИзделийКорабля
	|ГДЕ
	|	ЭкземплярыКомплектующихИзделийКорабля.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец", Объект.Владелец);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПревышеноКоличество = (Выборка.Количество() >= Объект.Владелец.Количество);
	
КонецФункции

&НаКлиенте
Процедура ДатаИзготовленияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаВвода) И Объект.ДатаИзготовления > Объект.ДатаВвода Тогда
		
		Сообщить("Введенная дата изготовления больше даты ввода в эксплуатацию");
		Объект.ДатаИзготовления = Дата("00010101");
		
	ИначеЕсли Объект.ДатаИзготовления > ТекущаяДата() Тогда
		
		Сообщить("Введенная дата изготовления больше текущей!");
		Объект.ДатаИзготовления = Дата("00010101");
		
	ИначеЕсли Не ВведеннаяДатаКорректна(Объект.ДатаИзготовления, Объект.Ссылка) Тогда
		
		Сообщить("Введенная дата изготовления меньше одной из дат ТОиР и/или наработки (см. соотв. таблицы)");
		Объект.ДатаИзготовления = Дата("00010101");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаВводаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаИзготовления) И  Объект.ДатаВвода < Объект.ДатаИзготовления Тогда
		
		Сообщить("Введенная дата ввода в эксплуатацию меньше даты изготовления");
		Объект.ДатаВвода = Дата("00010101");
		
	ИначеЕсли Объект.ДатаВвода > ТекущаяДата() Тогда
		
		Сообщить("Дата изготовления больше текущей!");
		Объект.ДатаВвода = Дата("00010101");
		
	ИначеЕсли Не ВведеннаяДатаКорректна(Объект.ДатаВвода, Объект.Ссылка) Тогда
		
		Сообщить("Дата изготовления меньше одной из дат ТОиР и/или наработки (см. соотв. таблицы)");
		Объект.ДатаВвода = Дата("00010101");
		
	КонецЕсли;
	
КонецПроцедуры

//процедура проверяет наличие в регистрах истории ТОиР и Наработки записей под данному экземпляру,
//являющих более ранними, чем введенная дата
&НаСервереБезКонтекста
Функция ВведеннаяДатаКорректна(ВведеннаяДата, Экземпляр)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИсторияТОиРЭкземпляровКомплектующихИзделийКорабля.Период КАК Период
	|ИЗ
	|	РегистрСведений.ИсторияТОиРЭкземпляровКомплектующихИзделийКорабля КАК ИсторияТОиРЭкземпляровКомплектующихИзделийКорабля
	|ГДЕ
	|	ИсторияТОиРЭкземпляровКомплектующихИзделийКорабля.Экземпляр = &Экземпляр
	|	И ИсторияТОиРЭкземпляровКомплектующихИзделийКорабля.Период < &Дата
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НаработкаЭкземляровКомплектующихИзделийКорабля.Период
	|ИЗ
	|	РегистрСведений.НаработкаЭкземляровКомплектующихИзделийКорабля КАК НаработкаЭкземляровКомплектующихИзделийКорабля
	|ГДЕ
	|	НаработкаЭкземляровКомплектующихИзделийКорабля.Экземпляр = &Экземпляр
	|	И НаработкаЭкземляровКомплектующихИзделийКорабля.Период < &Дата";
	Запрос.УстановитьПараметр("Экземпляр", Экземпляр);
	Запрос.УстановитьПараметр("Дата", ВведеннаяДата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПревышеноКоличество Тогда
		
		ПоказатьПредупреждение(, "С учетом добавляемого экземпляра количество экземпляров изделия превышает указанное в карточке!");
		
	КонецЕсли;
	
КонецПроцедуры
