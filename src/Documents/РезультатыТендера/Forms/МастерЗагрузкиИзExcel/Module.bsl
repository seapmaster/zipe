///////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область ВспомогательныеПроцедурыИФункции

&НаСервере
Функция ПолучитьЗначение(НомерСтроки, НомерКолонки, ЧисловоеЗначение = Ложь)
	Попытка
		ИмяОбласти 		= "R" + Формат(НомерСтроки, "ЧГ=") +"C" + Формат(НомерКолонки);
		СтрокаДанных 	= ДанныеExcel.Область(ИмяОбласти).Текст;
		СтрокаДанных 	= СокрЛП(СтрокаДанных);
		Если ЧисловоеЗначение Тогда
			Результат 	= СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрокаДанных);
		Иначе
			Результат 	= СтрокаДанных;
		КонецЕсли;
	Исключение
		Результат 		= ?(ЧисловоеЗначение, 0, "");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("" + ИмяОбласти + ": не удалось получить значение. " + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
КонецФункции // ПолучитьЗначение

&НаСервереБезКонтекста
Функция ПодготовитьТаблицу()
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Поставщик");
	Результат.Колонки.Добавить("ИдентификаторПредметаСнабжения");
	Результат.Колонки.Добавить("НаименованиеПредметаСнабжения");
	Результат.Колонки.Добавить("Количество");
	Результат.Колонки.Добавить("Цена");
	Возврат Результат;
КонецФункции // ПодготовитьТаблицу

&НаКлиенте
Функция ЗаполнитьНачальныеПараметрыПоискаВДокументе()
	НомерКолонкиНаименованиеПС 	= 3;
	НомерКолонкиИдентификаторПС = 2;
	НомерКолонкиКоличество		= 5;
	НомерНачальнойСтроки 		= 3;
	НомерПоследнейСтроки 		= ДанныеExcel.ВысотаТаблицы; 
КонецФункции // ЗаполнитьНачальныеПараметрыПоискаВДокументе

#КонецОбласти

#Область Действия

&НаКлиенте
Функция ПроверитьЗаполнениеПараметовЧтения()
	Результат = Истина;
	
	// Идентификатор ПС
	Если НомерКолонкиИдентификаторПС = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана колонка идентификатор предмета снабжения!", ,"НомерКолонкиИдентификаторПС");
		Результат = Ложь;
	ИначеЕсли НомерКолонкиИдентификаторПС > ДанныеExcel.ШиринаТаблицы Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Колонка идентификатора предмета снабжения выходит за границы таблицы!", ,"НомерКолонкиИдентификаторПС");
		Результат = Ложь;
	КонецЕсли; // Если НомерКолонкиИдентификаторПС = 0 Тогда
	
	// Наименования ПС
	Если НомерКолонкиНаименованиеПС = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана колонка наименования предмета снабжения!", ,"НомерКолонкиНаименованиеПС");
		Результат = Ложь;
	ИначеЕсли НомерКолонкиНаименованиеПС > ДанныеExcel.ШиринаТаблицы Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Колонка наименования предмета снабжения выходит за границы таблицы!", ,"НомерКолонкиНаименованиеПС");
		Результат = Ложь;
	КонецЕсли; // Если НомерКолонкиНаименованиеПС = 0 Тогда
	
	// Количество
	Если НомерКолонкиКоличество = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана колонка количества предмета снабжения!", ,"НомерКолонкиКоличество");
		Результат = Ложь;
	ИначеЕсли НомерКолонкиКоличество > ДанныеExcel.ШиринаТаблицы Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Колонка количества предмета снабжения выходит за границы таблицы!", ,"НомерКолонкиКоличество");
		Результат = Ложь;
	КонецЕсли; // Если НомерКолонкиКоличество = 0 Тогда
	
	// Начальная строка
	Если НомерНачальнойСтроки = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана начальная строка!", ,"НомерНачальнойСтроки");
		Результат = Ложь;
	ИначеЕсли НомерНачальнойСтроки > ДанныеExcel.ВысотаТаблицы Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Начальная строка выходит за границы таблицы!", ,"НомерНачальнойСтроки");
		Результат = Ложь;
	КонецЕсли; // Если НомерНачальнойСтроки = 0 Тогда 
	
	// Последняя строка
	Если НомерПоследнейСтроки = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана последняя строка!", ,"НомерПоследнейСтроки");
		Результат = Ложь;
	ИначеЕсли НомерПоследнейСтроки > ДанныеExcel.ВысотаТаблицы Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Последняя строка выходит за границы таблицы!", ,"НомерПоследнейСтроки");
		Результат = Ложь;
	КонецЕсли; // Если НомерНачальнойСтроки = 0 Тогда
		
	Если НомерНачальнойСтроки > НомерПоследнейСтроки Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Начальная строка должна быть меньше последней строки!", ,"НомерНачальнойСтроки");
		Результат = Ложь;
	КонецЕсли; // Если НомерНачальнойСтроки > НомерПоследнейСтроки Тогда	
	
	// Настройки колонок поставщиков
	Для Сч = 0 По НастройкиПоставщиков.Количество() - 1 Цикл
		СтрокаТаблицы = НастройкиПоставщиков[Сч];
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Поставщик) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Строка " + (Сч + 1) + ": не указан поставщик!", ,"НастройкиПоставщиков[" + Сч + "].Поставщик");
			Результат = Ложь;
		КонецЕсли; // Если Не ЗначениеЗаполнено(СтрокаТаблицы.Поставщик) Тогда
		
		Если СтрокаТаблицы.НомерКолонки = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Строка " + (Сч + 1) + ": не указан номер колонки!", ,"НастройкиПоставщиков[" + Сч + "].НомерКолонки");
			Результат = Ложь;
		ИначеЕсли СтрокаТаблицы.НомерКолонки > ДанныеExcel.ШиринаТаблицы Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Строка " + (Сч + 1) + ": колонка выходит за границы таблицы!", ,"НастройкиПоставщиков[" + Сч + "].НомерКолонки");
			Результат = Ложь;
		КонецЕсли; // Если Не ЗначениеЗаполнено(СтрокаТаблицы.Поставщик) Тогда
	КонецЦикла; // Для Каждого СтрокаТаблицы Из НастройкиПоставщиков Цикл
	
	Возврат Результат;
КонецФункции // ПроверитьЗаполнениеПараметовЧтения

&НаСервере
Процедура ЗаполнитьТаблицуПоставщиков()
	Если Параметры.Свойство("Поставщики")
		И ТипЗнч(Параметры.Поставщики) = Тип("Массив") Тогда
		Поставщики = Параметры.Поставщики;
	Иначе
		Возврат;
	КонецЕсли; // Если Параметры.Свойство("Поставщики") Тогда	
	
	НомерКолонки 	= 6;
	Для Каждого Поставщик Из Поставщики Цикл
		НоваяСтрока 				= НастройкиПоставщиков.Добавить();
		НоваяСтрока.Поставщик 		= Поставщик;
		НоваяСтрока.НомерКолонки 	= НомерКолонки;
		НомерКолонки 				= НомерКолонки + 1;
	КонецЦикла; // Для Каждого ЭлементСписка Из Поставщики Цикл		
КонецПроцедуры // ЗаполнитьТаблицуПоставщиков

&НаСервере
Функция СформироватьТаблицу()
	ТаблицаДанных 	= ПодготовитьТаблицу();	
	Для Сч = НомерНачальнойСтроки По НомерПоследнейСтроки Цикл
		ИдентификаторПредметаСнабжения 	= ПолучитьЗначение(Сч, НомерКолонкиИдентификаторПС);
		Если ИдентификаторПредметаСнабжения = "" Тогда
			Продолжить;
		КонецЕсли; // Если ИдентификаторПредметаСнабжения = "" Тогда
		
		НаименованиеПредметаСнабжения 	= ПолучитьЗначение(Сч, НомерКолонкиНаименованиеПС);
		Количество 						= ПолучитьЗначение(Сч, НомерКолонкиКоличество, Истина);
		Для Каждого СтрокаПоставщики Из НастройкиПоставщиков Цикл
			СтрокаТаблицыДанных 								= ТаблицаДанных.Добавить();
			СтрокаТаблицыДанных.Поставщик	 					= СтрокаПоставщики.Поставщик;
			СтрокаТаблицыДанных.ИдентификаторПредметаСнабжения	= ИдентификаторПредметаСнабжения;
			СтрокаТаблицыДанных.НаименованиеПредметаСнабжения 	= НаименованиеПредметаСнабжения;
			СтрокаТаблицыДанных.Цена 							= ПолучитьЗначение(Сч, СтрокаПоставщики.НомерКолонки, Истина);
			СтрокаТаблицыДанных.Количество 						= Количество;
		КонецЦикла; // Для Каждого СтрокаПоставщики Из НастройкиПоставщиков Цикл		
	КонецЦикла; //Для Сч = НомерНачальнойСтроки По НомерПоследнейСтроки Цикл
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаДанных, Новый УникальныйИдентификатор);
КонецФункции // СформироватьТаблицу

#КонецОбласти

#Область CallBackМетоды

&НаКлиенте
Процедура ПослеПомещенияФайлаНаСервер(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если Результат = Неопределено Тогда
	
	ИмяФайла = Результат.СсылкаНаФайл.Файл.ПолноеИмя;
	
	ПараметрыФайла = Новый Структура; 
	ПараметрыФайла.Вставить("Расширение", Результат.СсылкаНаФайл.Расширение);
	
	ДанныеExcel = РаботаСФайламиOffice.ПрочитатьФайлВТабличныйДокумент(Результат.Адрес, ПараметрыФайла);
	
	ЗаполнитьНачальныеПараметрыПоискаВДокументе();
	
КонецПроцедуры // ПослеПомещенияФайлаНаСервер


#КонецОбласти

///////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД 

#Область Команды

&НаКлиенте
Процедура КомандаПеренестиВДокумент(Команда)
	Если Не ПроверитьЗаполнениеПараметовЧтения() Тогда
		Возврат;
	КонецЕсли; // Если Не ПроверитьЗаполнениеПараметовЧтения() Тогда
	
	АдресВременногоХранилища = СформироватьТаблицу();
	Если АдресВременногоХранилища = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если АдресВременногоХранилища = Неопределено Тогда
	
	Закрыть(АдресВременногоХранилища);
КонецПроцедуры // КомандаПеренестиВДокумент

#КонецОбласти

///////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

#Область СобытияФормыИЭлементов

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьТаблицуПоставщиков();	
КонецПроцедуры // ПриСозданииНаСервере

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка				= Ложь;
	
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыДиалога.МножественныйВыбор = Ложь;
	ПараметрыДиалога.Заголовок 			= "Файл с данными тендера";
   	ПараметрыДиалога.Фильтр 			= "Файлы Excel|*.xls;*.xlsx";
	
	ОписаниеЗавершения = Новый ОписаниеОповещения("ПослеПомещенияФайлаНаСервер", ЭтаФорма);
	НачатьПомещениеФайлаНаСервер(ОписаниеЗавершения,,,,ПараметрыДиалога, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры // ИмяФайлаНачалоВыбора

#КонецОбласти