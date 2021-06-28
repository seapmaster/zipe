////////////////////////////////////////////////////////////////////////////////
// Программный интерфейс для подсистемы бизнес-процессов и задач.

// Получить структуру с описанием формы выполнения задачи.
// Вызывается при открытии формы выполнения задачи.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   ТочкаМаршрутаБизнесПроцесса - точка маршрута.
//
// Возвращаемое значение:
//   Структура   - структуру с описанием формы выполнения задачи.
//                 Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//                 Ключ "ПараметрыФормы" содержит параметры формы. 
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
	Результат 	= Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	
	Если ТочкаМаршрутаБизнесПроцесса 		= БизнесПроцессы.РаспределениеЗаявкиФСВТС.ТочкиМаршрута.НазначениеРегиональногоРуководителя Тогда
		Результат.Вставить("ИмяФормы", "БизнесПроцесс.РаспределениеЗаявкиФСВТС.Форма.ФормаНазначенияРегиональногоРуководителя");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса 	= БизнесПроцессы.РаспределениеЗаявкиФСВТС.ТочкиМаршрута.НазначениеЭксперта Тогда
		Результат.Вставить("ИмяФормы", "БизнесПроцесс.РаспределениеЗаявкиФСВТС.Форма.ФормаНазначенияЭксперта");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса 	= БизнесПроцессы.РаспределениеЗаявкиФСВТС.ТочкиМаршрута.РаспределениеПоИсполнителям Тогда
		Результат.Вставить("ИмяФормы", "БизнесПроцесс.РаспределениеЗаявкиФСВТС.Форма.ФормаРаспределенияПоИсполнителям");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса 	= БизнесПроцессы.РаспределениеЗаявкиФСВТС.ТочкиМаршрута.РедактированиеРаспределения Тогда
		Результат.Вставить("ИмяФормы", "БизнесПроцесс.РаспределениеЗаявкиФСВТС.Форма.ФормаРедактированияРаспределения");
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса 	= БизнесПроцессы.РаспределениеЗаявкиФСВТС.ТочкиМаршрута.ФормированиеДокументов Тогда
		Результат.Вставить("ИмяФормы", "БизнесПроцесс.РаспределениеЗаявкиФСВТС.Форма.ФормаФормированияДокументов");
	КонецЕсли; // Если ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.РаспределениеЗаявкиФСВТС.ТочкиМаршрута.НазначениеРегиональногоРуководителя Тогда

	Возврат Результат;
	
КонецФункции // ФормаВыполненияЗадачи

// Вызывается при перенаправлении задачи.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - перенаправляемая задача.
//   НоваяЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка, НоваяЗадачаСсылка) Экспорт
	
	БизнесПроцессОбъект = ЗадачаСсылка.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцессОбъект.Ссылка);
	БизнесПроцессОбъект.РезультатВыполнения = РезультатВыполненияПриПеренаправлении(ЗадачаСсылка) 
		+ БизнесПроцессОбъект.РезультатВыполнения;
	УстановитьПривилегированныйРежим(Истина);
	БизнесПроцессОбъект.Записать();
	
КонецПроцедуры

// Вызывается при выполнении задачи из формы списка.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   БизнесПроцессСсылка - БизнесПроцессСсылка - бизнес-процесс, по которому сформирована задача ЗадачаСсылка.
//   ТочкаМаршрутаБизнесПроцесса - точка маршрута.
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
КонецПроцедуры // ОбработкаВыполненияПоУмолчанию	

Функция РезультатВыполненияПриПеренаправлении(Знач ЗадачаСсылка)  
	
	СтрокаФормат = НСтр("ru = '%1, %2 перенаправил(а) задачу:
		|%3
		|'");
	
	Комментарий = СокрЛП(ЗадачаСсылка.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат, ЗадачаСсылка.ДатаИсполнения, ЗадачаСсылка.Исполнитель, Комментарий);
	Возврат Результат;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные процедуры и функции

Функция СуществуютПроцессыПоЗявке(Заявка, ТолькоАктивные = Ложь) Экспорт
	Результат 		= Ложь;
	Запрос 			= Новый Запрос;
	Запрос.Текст 	= "ВЫБРАТЬ
		               |	РаспределениеЗаявкиФСВТС.Ссылка КАК Ссылка
		               |ИЗ
		               |	БизнесПроцесс.РаспределениеЗаявкиФСВТС КАК РаспределениеЗаявкиФСВТС
		               |ГДЕ
		               |	РаспределениеЗаявкиФСВТС.Заявка = &Заявка
		               |	И НЕ РаспределениеЗаявкиФСВТС.ПометкаУдаления";   
	Запрос.УстановитьПараметр("Заявка", Заявка);
	Если ТолькоАктивные Тогда
		Запрос.Текст 	= Запрос.Текст + " И Не РаспределениеЗаявкиФСВТС.Завершен";
	КонецЕсли; // Если ТолькоАктивные Тогда
	Выборка 			= Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат 		= Истина;
	КонецЕсли; // Если Выборка.Следующий() Тогда
	
	Возврат Результат;
КонецФункции // СуществуютПроцессыПоЗявке

Функция ПолучитьБизнесПроцесс(Заявка) Экспорт
	Результат 		= Неопределено;	
	Если Не ЗначениеЗаполнено(Заявка) Тогда
		Возврат Результат;
	КонецЕсли; // Если Не ЗначениеЗаполнено(Заявка) Тогда	
	
	Запрос 			= Новый Запрос;
	Запрос.Текст 	= "ВЫБРАТЬ
	             	  |	РаспределениеЗаявкиФСВТС.Ссылка КАК Ссылка
	             	  |ИЗ
	             	  |	БизнесПроцесс.РаспределениеЗаявкиФСВТС КАК РаспределениеЗаявкиФСВТС
	             	  |ГДЕ
	             	  |	НЕ РаспределениеЗаявкиФСВТС.ПометкаУдаления
	             	  |	И РаспределениеЗаявкиФСВТС.Заявка = &Заявка";
	Запрос.УстановитьПараметр("Заявка", Заявка);
	Выборка 		= Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат 	= Выборка.Ссылка;
	КонецЕсли; // Если Выборка.Следующий() Тогда	
	Возврат Результат;
КонецФункции // ПолучитьБизнесПроцесс

Функция Создать(Заявка) Экспорт
	Результат 				= Неопределено;
	
	БизнесПроцесс 			= БизнесПроцессы.РаспределениеЗаявкиФСВТС.СоздатьБизнесПроцесс();
	БизнесПроцесс.Заявка 	= Заявка;
	БизнесПроцесс.Дата 		= ТекущаяДата();
	Попытка
		БизнесПроцесс.Записать();
		БизнесПроцесс.Старт();
		Результат			= БизнесПроцесс.Ссылка;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось запустить бизнес процесс: " + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
КонецФункции // Создать

