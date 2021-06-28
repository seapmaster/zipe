///////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область ПолучениеДанных

&НаСервереБезКонтекста
Функция ПолучитьМассивПоставщиковИзТабличнойЧасти(Цены)
	Таблица 			= Цены.Скопировать();
	Таблица.Свернуть("Поставщик");
	Возврат Таблица.ВыгрузитьКолонку("Поставщик");
КонецФункции // ПолучитьМассивПоставщиковИзТабличнойЧасти

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруПоиска(СтрокаТабличнойЧастиЦены)
	Результат = Новый Структура("ИдентификаторПредметаСнабжения,ПредметСнабжения,ЕдиницаИзмерения,Количество");
	ЗаполнитьЗначенияСвойств(Результат, СтрокаТабличнойЧастиЦены);
	Возврат Результат;
КонецФункции // ПолучитьСтруктуруПоиска

&НаКлиенте
Функция ПолучитьМассивПоставщиковИзСписка(Поставщики)
	Результат = Новый Массив;
	Для Каждого ЭлементСписка Из Поставщики Цикл
		Если ЭлементСписка.Значение = Неопределено Тогда
			Продолжить;
		КонецЕсли; // Если ЭлементСписка.Значение = Неопределено Тогда		
		Результат.Добавить(ЭлементСписка.Значение);
	КонецЦикла; // Для Каждого ЭлементСписка Из Поставщики Цикл	
	Возврат Результат;
КонецФункции // ПолучитьМассивПоставщиковИзСписка

&НаСервере
Функция ПолучитьСписокВыбора(Обозначение)
	Возврат Справочники.КаталогПредметовСнабжения.ПолучитьСписокПодобных(Обозначение);
КонецФункции // ПолучитьСписокВыбора

#КонецОбласти

#Область ЗаполнениеДанных

&НаСервере
Процедура ЗаполнитьТаблицуЦенПоТабличнойЧасти()
	Если Поставщики.Количество() > 0 Тогда
		УдалитьРеквизитыПоставщиков();
	КонецЕсли; // Если Поставщики.Количество() > 0 Тогда
	
	Поставщики.Очистить();
	ТаблицаЦен.Очистить();
	ЦеныПоставщиков.Очистить();
	ПредметыСнабжения.Очистить();
	
	// Заполним список поставщиков
	ТабличнаяЧасть 	= Объект.Цены.Выгрузить();
	Поставщики.ЗагрузитьЗначения(ПолучитьМассивПоставщиковИзТабличнойЧасти(ТабличнаяЧасть));
	
	// Дополним реквизиты "ТаблицаЦен", добавим элементы на форму
	Для Каждого ЭлементСпискаПоставщиков Из Поставщики Цикл
		ДобавитьПоставщика(ЭлементСпискаПоставщиков.Значение, Поставщики.Индекс(ЭлементСпискаПоставщиков));
	КонецЦикла; // Для Каждого ЭлементСпискаПоставщиков Из Поставщики Цикл	
	
	// Заполним "ПредметыСнабжения" и "ЦеныПоставщиков"
	Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл
		НайденныеСтроки = ПредметыСнабжения.НайтиСтроки(ПолучитьСтруктуруПоиска(СтрокаТабличнойЧасти));
		Если НайденныеСтроки.Количество() = 0 Тогда
			СтрокаПредметыСнабжения = ДобавитьСтрокуПредметыСнабжения(СтрокаТабличнойЧасти);
		Иначе
			СтрокаПредметыСнабжения = НайденныеСтроки[0];
		КонецЕсли; // Если НайденныеСтроки.Количество() = 0 Тогда
		
		СтрокаЦеныПоставщиков 						= ЦеныПоставщиков.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЦеныПоставщиков, СтрокаТабличнойЧасти);
		СтрокаЦеныПоставщиков.ИдентификаторСтрокиПС = СтрокаПредметыСнабжения.ИдентификаторСтроки;
	КонецЦикла; // Для Каждого СтрокаТабличнойЧасти Из ТабличнаяЧасть Цикл	
	
	// Соберем таблицу цен
	Для Каждого СтрокаПредметыСнабжения Из ПредметыСнабжения Цикл
		НоваяСтрокаТаблицыЦен 		= ТаблицаЦен.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТаблицыЦен, СтрокаПредметыСнабжения);
		НоваяСтрокаТаблицыЦен.ОбозначениеПредметаСнабжения = СтрокаПредметыСнабжения.ПредметСнабжения.Обозначение;
		
		Для Каждого ЭлементСпискаПоставщиков Из Поставщики Цикл
			НайденныеСтрокиЦенПоставщиков = ЦеныПоставщиков.НайтиСтроки(Новый Структура("ИдентификаторСтрокиПС,
																							| Поставщик",
																							СтрокаПредметыСнабжения.ИдентификаторСтроки,
																							ЭлементСпискаПоставщиков.Значение));
			Если НайденныеСтрокиЦенПоставщиков.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли; // Если НайденныеСтрокиЦенПоставщиков.Количество() = 0 Тогда
			
			ИндексПоставщика 		= Поставщики.Индекс(ЭлементСпискаПоставщиков);
			НоваяСтрокаТаблицыЦен["Поставщик" + ИндексПоставщика] = НайденныеСтрокиЦенПоставщиков[0].Цена;
		КонецЦикла; // Для Каждого ЭлементСпискаПоставщиков Из Поставщики Цикл
		
	КонецЦикла; // Для Каждого СтрокаПредметыСнабжения Из ПредметыСнабжения Цикл	
	
КонецПроцедуры // ЗаполнитьТаблицуЦенПоТабличнойЧасти

&НаСервере
Процедура ЗаполнитьТабличнуюЧастьПоТаблицеЦен(ТабличнаяЧасть)
	ТабличнаяЧасть.Очистить();
	Для Каждого СтрокаТаблицыЦен Из ТаблицаЦен Цикл
		Для Каждого ЭлементСпискаПоставщиков Из Поставщики Цикл
			Если ЭлементСпискаПоставщиков.Значение = Неопределено Тогда
				Продолжить;
			КонецЕсли; // Если ЭлементСпискаПоставщиков.Значение = Неопределено Тогда			
			ИндекстПоставщика 		= Поставщики.Индекс(ЭлементСпискаПоставщиков);
			НоваяСтрока 			= ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицыЦен);
			НоваяСтрока.Поставщик	= ЭлементСпискаПоставщиков.Значение;
			НоваяСтрока.Цена 		= СтрокаТаблицыЦен["Поставщик" + ИндекстПоставщика];
		КонецЦикла; // Для Каждого ЭлементСпискаПоставщиков Из Поставщики Цикл		
	КонецЦикла; // Для Каждого СтрокаТаблицыЦен Из ТаблицаЦен Цикл	
КонецПроцедуры // ЗаполнитьТаблицуЦенПоТабличнойЧасти

&НаСервере
Процедура ЗаполнитьПредметыСнабжения()
	Для Каждого СтрокаТаблицы Из ТаблицаЦен Цикл
		СтрокаТаблицы.ПредметСнабжения = Справочники.КаталогПредметовСнабжения.НайтиПоОбозначению(СтрокаТаблицы.ИдентификаторПредметаСнабжения);
		ПриИзмененииПредметаСнабжения(ТаблицаЦен.Индекс(СтрокаТаблицы));
	КонецЦикла; // Для Каждого СтрокаТаблицы Из ТаблицаЦен Цикл	
КонецПроцедуры // ПодобратьПредметыСнабжения

&НаСервере
Процедура ЗаполнитьПредметыСнабженияПоЗаказу()
	ПредметыСнабжения.Очистить();
	ЦеныПоставщиков.Очистить();
	Для Каждого СтрокаСпецификации Из Объект.Заказ.Спецификация Цикл
		НоваяСтрока 								= ПредметыСнабжения.Добавить();
		НоваяСтрока.ИдентификаторСтроки 			= Новый УникальныйИдентификатор;
		НоваяСтрока.ИдентификаторПредметаСнабжения 	= СтрокаСпецификации.ПредметСнабжения.Обозначение;
		НоваяСтрока.НаименованиеПредметаСнабжения 	= СтрокаСпецификации.ПредметСнабжения.Наименование;
		НоваяСтрока.ПредметСнабжения 				= СтрокаСпецификации.ПредметСнабжения;
		НоваяСтрока.ЕдиницаИзмерения 				= СтрокаСпецификации.ПредметСнабжения.ЕдиницаИзмерения;
		НоваяСтрока.Количество 						= СтрокаСпецификации.Количество;
	КонецЦикла; // Для Каждого СтрокаСпецификации Из Объект.Заказ.Спецификация Цикл
	
	СформироватьТаблицуЦен();
КонецПроцедуры // ЗаполнитьПредметыСнабженияПоЗаказу

#КонецОбласти

#Область Действия

&НаСервере
Функция ДобавитьСтрокуПредметыСнабжения(СтрокаТабличнойЧасти)
	НоваяСтрока 					= ПредметыСнабжения.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
	НоваяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор;
	Возврат НоваяСтрока;
КонецФункции // ДобавитьСтрокуПредметыСнабжения

&НаСервере
Процедура УдалитьРеквизитыПоставщиков()
	Для Каждого ЭлементСписка Из Поставщики Цикл
		Если ЭлементСписка.Значение = Неопределено Тогда
			Продолжить;
		КонецЕсли; // Если ЭлементСписка.Значение = Неопределено Тогда		
		УдалитьПоставщика(ЭлементСписка.Значение);
	КонецЦикла; // Для Каждого ЭлементСписка Из Поставщики Цикл	
КонецПроцедуры // УдалитьРеквизитыПоставщиков

&НаСервере
Процедура ДобавитьПоставщика(Поставщик, Индекс)
		
	// Добавляем колонку в таблицу значений "Таблица цен"
	Тип 					= Новый ОписаниеТипов("Число",,, 
														Новый КвалификаторыЧисла(15,3, ДопустимыйЗнак.Неотрицательный));
	ДобавляемыеРеквизиты 	= Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("Поставщик" + Индекс, 
														Тип, 
														"ТаблицаЦен", 
														Строка(Поставщик)));	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);	

	// Добавляем колонку на форме
	ЭлементФормыРеквизитТаблицы 				= Элементы.Добавить("ТаблицаЦенПоставщик" + Индекс, 
																		Тип("ПолеФормы"), 
																		Элементы.ТаблицаЦен);
	ЭлементФормыРеквизитТаблицы.ПутьКДанным 	= "ТаблицаЦен.Поставщик" + Индекс;
	ЭлементФормыРеквизитТаблицы.Вид 			= ВидПоляФормы.ПолеВвода;
	ЭлементФормыРеквизитТаблицы.ВыбиратьТип 	= Ложь;
	ЭлементФормыРеквизитТаблицы.КнопкаОчистки 	= Истина;
	
КонецПроцедуры // ДобавитьПоставщика

&НаСервере
Процедура УдалитьПоставщика(Поставщик)
	
	ЭлементСпискаПоставщиков 	= Поставщики.НайтиПоЗначению(Поставщик);
	Если ЭлементСпискаПоставщиков = Неопределено Тогда
		Возврат;
	Иначе
		Индекс					= Поставщики.Индекс(ЭлементСпискаПоставщиков);
	КонецЕсли; // Если ЭлементСпискаПоставщиков = Неопределено Тогда
	
	// Удалим колонку из таблицы значений "ТаблицаЦен"
	УдаляемыеРеквизиты 			= Новый Массив;
	УдаляемыеРеквизиты.Добавить("ТаблицаЦен.Поставщик" + Индекс);
	ИзменитьРеквизиты(,УдаляемыеРеквизиты);
	
	// Удалим колонку на форме
	Колонка						 = Элементы.Найти("ТаблицаЦенПоставщик" + Индекс);
	Если Не Колонка = Неопределено Тогда
		Элементы.Удалить(Колонка);
	КонецЕсли; // Если Не Колонка = Неопределено Тогда
	
	// В списке поставщиков обнулим значение (но не удаляем,
	// дабы не нарушить нумерацию колонок)
	ЭлементСпискаПоставщиков.Значение = Неопределено;
КонецПроцедуры // УдалитьПоставщика

&НаСервере
Процедура СформироватьТаблицуЦен()
	ТаблицаЦен.Очистить();
	Для Каждого СтрокаТаблицыПредметовСнабжения Из ПредметыСнабжения Цикл
		НоваяСтрокаТаблицыЦен = ТаблицаЦен.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТаблицыЦен, СтрокаТаблицыПредметовСнабжения);    		
	КонецЦикла; // Для Каждого СтрокаТаблицыПредметовСнабжения Из ПредметыСнабжения Цикл
	
КонецПроцедуры // СформироватьТаблицуЦен

&НаКлиенте
Процедура ПредупредитьОбОчистке()
	Оповещение 	= Новый ОписаниеОповещения("CallBack_ПредупредитьОбОчистке", ЭтаФорма);
	ПоказатьВопрос(Оповещение,
					"Таблица цен содержит данные. 
					|При заполнении предметов снабжения по заказу текущие данные будут очищены.
					|Продолжить заполнение?",
					РежимДиалогаВопрос.ДаНет,
					30,
					КодВозвратаДиалога.Нет,
					"Внимание!",
					КодВозвратаДиалога.Нет);
КонецПроцедуры // ПредупредитьОбОчистке

&НаСервере
Процедура ЗагрузитьЦеныНаСервере(АдресАременногоХранилища)
	Объект.Цены.Загрузить(ПолучитьИзВременногоХранилища(АдресАременногоХранилища));
	ЗаполнитьТаблицуЦенПоТабличнойЧасти();
	ЗаполнитьПредметыСнабжения();
КонецПроцедуры // ЗагрузитьЦеныНаСервере

&НаСервере
Процедура ПриИзмененииПредметаСнабжения(Индекс, ПерезаполнятьРеквизиты = Ложь)
	СтрокаТаблицы 					= ТаблицаЦен.Получить(Индекс);
	Если Не ЗначениеЗаполнено(СтрокаТаблицы.ПредметСнабжения) Тогда
		Возврат;
	КонецЕсли; // Если Не ЗначениеЗаполнено(СтрокаТаблицы.ПредметСнабжения) Тогда
	
	СтрокаТаблицы.ЕдиницаИзмерения 				= СтрокаТаблицы.ПредметСнабжения.ЕдиницаИзмерения;
	СтрокаТаблицы.ОбозначениеПредметаСнабжения 	= СтрокаТаблицы.ПредметСнабжения.Обозначение;
	
	Если ПерезаполнятьРеквизиты 
		Или
		(Не ПерезаполнятьРеквизиты
		И Не ЗначениеЗаполнено(СтрокаТаблицы.НаименованиеПредметаСнабжения)) Тогда
		СтрокаТаблицы.НаименованиеПредметаСнабжения = СтрокаТаблицы.ПредметСнабжения.Наименование;
	КонецЕсли; // Если ПерезаполнятьРеквизиты     	
	
	Если ПерезаполнятьРеквизиты 
		Или
		(Не ПерезаполнятьРеквизиты
		И Не ЗначениеЗаполнено(СтрокаТаблицы.ИдентификаторПредметаСнабжения)) Тогда
		СтрокаТаблицы.ИдентификаторПредметаСнабжения = СтрокаТаблицы.ПредметСнабжения.Обозначение;
	КонецЕсли; // Если ПерезаполнятьРеквизиты
	
КонецПроцедуры // ПриИзмененииПредметаСнабжения

#КонецОбласти

#Область CallBack

&НаКлиенте
Процедура CallBack_УдалитьПоставщика(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт 
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если ВыбранноеЗначение = Неопределено Тогда
	
	УдалитьПоставщика(ВыбранноеЗначение.Значение);
КонецПроцедуры // CallBack_УдалитьПоставщика

&НаКлиенте
Процедура CallBack_ДобавитьПоставщика(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт 
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если ВыбранноеЗначение = Неопределено Тогда
	
	// Проверка на наличие поставщика в таблице
	Если Не Поставщики.НайтиПоЗначению(ВыбранноеЗначение) = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Поставщик [" + ВыбранноеЗначение + "] уже присутствует в таблице!");
		Возврат;
	Иначе
		ЭлементСписка = Поставщики.Добавить(ВыбранноеЗначение);
	КонецЕсли; // Если Не Поставщики.Найти(ВыбранноеЗначение) = Неопределено Тогда
	
	ДобавитьПоставщика(ВыбранноеЗначение, Поставщики.Индекс(ЭлементСписка));
КонецПроцедуры // CallBack_ДобавитьПоставщика

&НаКлиенте
Процедура CallBack_ЗагрузитьИзExcel(АдресАременногоХранилища, ДополнительныеПараметры) Экспорт 
	Если АдресАременногоХранилища = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если АдресАременногоХранилища = Неопределено Тогда
	
	ЗагрузитьЦеныНаСервере(АдресАременногоХранилища);
КонецПроцедуры // ЗагрузитьЦены

&НаКлиенте
Процедура CallBack_ПредупредитьОбОчистке(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если Результат = Неопределено Тогда
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПредметыСнабженияПоЗаказу();
	КонецЕсли; // Если Результат = КодВозвратаДиалога.Да Тогда	
КонецПроцедуры // ПослеЗакрытияВопроса

#КонецОбласти

///////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

#Область Команды

&НаКлиенте
Процедура КомандаДобавитьПоставщика(Команда)
	Оповещение = Новый ОписаниеОповещения("CallBack_ДобавитьПоставщика", ЭтотОбъект);
	ПоказатьВводЗначения(Оповещение, 
		ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"),
		"Выберите поставщика:",
		Тип("СправочникСсылка.Организации"));
КонецПроцедуры // КомандаДобавитьПоставщика

&НаКлиенте
Процедура КомандаУдалитьПоставщика(Команда)
	Если Поставщики.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Таблица не содержит ни одного поставщика!");
		Возврат;
	КонецЕсли; // Если Поставщики.Количество() = 0 Тогжа
	
	Оповещение = Новый ОписаниеОповещения("CallBack_УдалитьПоставщика", ЭтотОбъект);
	Поставщики.ПоказатьВыборЭлемента(Оповещение, "Выберите поставщика для удаления");
КонецПроцедуры // КомандаУдалитьПоставщика

&НаКлиенте
Процедура КомандаЗаполнитьПредметыСнабженияПоЗаказу(Команда)
	Если Не ЗначениеЗаполнено(Объект.Заказ) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заказ не выбран. Заполнение предметов снабжения по заказу невозможно!");
		Возврат;
	КонецЕсли; // Если Не ЗначениеЗаполнено(Объект.Заказ) Тогда
	
	Если ТаблицаЦен.Количество() > 0 Тогда   		
		ПредупредитьОбОчистке();
	Иначе
		ЗаполнитьПредметыСнабженияПоЗаказу();
	КонецЕсли; // Если ТаблицаЦен.Количество() > 0 Тогда
	
КонецПроцедуры // КомандаЗаполнитьПредметыСнабженияПоЗаказу

&НаКлиенте
Процедура КомандаЗагрузитьДанныеТендераИзExcel(Команда)
	ПараметрыОткрытия = Новый Структура("Поставщики", ПолучитьМассивПоставщиковИзСписка(Поставщики));
	ОписаниеОповещения = Новый ОписаниеОповещения("CallBack_ЗагрузитьИзExcel", ЭтаФорма);
	ОткрытьФорму("Документ.РезультатыТендера.Форма.МастерЗагрузкиИзExcel", ПараметрыОткрытия,,,,, ОписаниеОповещения);
КонецПроцедуры // КомандаЗагрузитьДанныеТендераИзExcel

#КонецОбласти

///////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

#Область ОбработчикиФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьТаблицуЦенПоТабличнойЧасти();
КонецПроцедуры // ПриСозданииНаСервере

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьТабличнуюЧастьПоТаблицеЦен(ТекущийОбъект.Цены);
КонецПроцедуры // ПередЗаписьюНаСервере

#КонецОбласти

#Область ОбработчикиТаблицыЦен

&НаКлиенте
Процедура ТаблицаЦенПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если ТекущаяСтрока = Неопределено Тогда
	
	Если НоваяСтрока Или Копирование Тогда
		ТекущаяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор;
	КонецЕсли; // Если НоваяСтрока Или Копирование Тогда	
КонецПроцедуры // ТаблицаЦенПриНачалеРедактирования

&НаКлиенте
Процедура ТаблицаЦенПредметСнабженияПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.ТаблицаЦен.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если ТекущаяСтрока = Неопределено Тогда
	
	ПриИзмененииПредметаСнабжения(ТаблицаЦен.Индекс(ТекущаяСтрока));
КонецПроцедуры // ТаблицаЦенПредметСнабженияПриИзменении

&НаКлиенте
Процедура ТаблицаЦенПредметСнабженияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если Ожидание = 0 Тогда
		ТекущаяСтрока 				= Элементы.ТаблицаЦен.ТекущиеДанные;
		СписокВыбора 				= ПолучитьСписокВыбора(ТекущаяСтрока.ИдентификаторПредметаСнабжения);
		Если СписокВыбора.Количество() > 0 Тогда
			СтандартнаяОбработка 	= Ложь;
			ДанныеВыбора 			= СписокВыбора;		
		КонецЕсли; // Если СписокВыбора.Количество() > 0 Тогда
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
