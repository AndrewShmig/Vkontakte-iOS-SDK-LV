//
// Created by AndrewShmig on 6/28/13.
//
// Copyright (c) 2013 Andrew Shmig
// 
// Permission is hereby granted, free of charge, to any person 
// obtaining a copy of this software and associated documentation 
// files (the "Software"), to deal in the Software without 
// restriction, including without limitation the rights to use, 
// copy, modify, merge, publish, distribute, sublicense, and/or 
// sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following 
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
// THE SOFTWARE.
//
#import <Foundation/Foundation.h>

/** Перечисление возможных сроков действия кэша.
*/
typedef enum
{

    VKCachedDataLiveTimeNever = 0,
    VKCachedDataLiveTimeOneMinute = 60,
    VKCachedDataLiveTimeThreeMinutes = 3 * 60,
    VKCachedDataLiveTimeFiveMinutes = 5 * 60,
    VKCachedDataLiveTimeOneHour = 1 * 60 * 60,
    VKCachedDataLiveTimeFiveHours = 5 * 60 * 60,
    VKCachedDataLiveTimeOneDay = 24 * 60 * 60,
    VKCachedDataLiveTimeOneWeek = 7 * 24 * 60 * 60,
    VKCachedDataLiveTimeOneMonth = 30 * 24 * 60 * 60,
    VKCachedDataLiveTimeOneYear = 365 * 24 * 60 * 60,

} VKCachedDataLiveTime;

/** Класс предназначен для хранения, получения, удаления кэша запросов.
Хранение кэша осуществляется на диске и в директории указанной при инициализации
класса.
*/
@interface VKCachedData : NSObject

/**
@name Методы инициализации
*/
/** Инициализация объекта для кэширования запросов

@param path директория в которой должны будут храниться кэшируемые данные.
Если директория не существует, то будет создана.
@return объект типа VKCachedData
*/
- (instancetype)initWithCacheDirectory:(NSString *)path;

/**
@name Методы манипуляции с кэшем
*/
/** Добавляет данные в кэш

По умолчанию время жизни кэша устанавливается равным одному часу.

@param cache данные, которые необходимо закэшировать
@param url URL который соответствует кешируемым данным
*/
- (void)addCachedData:(NSData *)cache forURL:(NSURL *)url;

/** Добавляет данные в кэш

@param cache данные, которые необходимо закэшировать
@param url URL который соответствует кешируемым данным
@param cacheLiveTime время жизни кэша. Возможные варианты перечислены в VKCachedDataLiveTime
(VKCachedDataLiveTimeOneHour, VKCachedDataLiveTimeOneDay, VKCachedDataLiveTimeForever etc)
*/
- (void)addCachedData:(NSData *)cache
               forURL:(NSURL *)url
             liveTime:(VKCachedDataLiveTime)cacheLiveTime;

/** Удаление кэша указанного URL

@param url URL, закэшированные данные которого необходимо удалить
*/
- (void)removeCachedDataForURL:(NSURL *)url;

/** Удаление всех закэшированных данных в директории, которой был инициализирован
данный объект
*/
- (void)clearCachedData;

/** Удаление директории с данными кэша
*/
- (void)removeCachedDataDirectory;

/**
@name Получение закэшированных данных
*/
/** Возвращает закэшированные данные по указанному URL, либо nil, если время действия
кэша истекло или его нет.

@param url URL, закэшированные данные по которому необходимо получить
@return экземпляр класса NSData, закэшированные данные указанного URL
*/
- (NSData *)cachedDataForURL:(NSURL *)url;

/** Возвращает закэшированные данные по указанному URL, либо nil, если для данного
запроса нет кэша.

Параметр offlineMode влияет на возвращаемые данные следующим образом: если передается
YES и в кэше есть данные для этого URL, но срок их жизни истек, то они всё равно
будут возвращены (без удаления, до последующего обновления).
Если параметр offlineMode равен NO, то при запросе данных из кэша, они будут
удалены в случае, если время жизни данных истекло.

Использование данного метода с передачей значения YES в параметре offlineMode
полезно при отсутствии интернет соединения.

@param url URL, закэшированные данные по которому необходимо получить
@param offlineMode оффлайн режим запроса кэша (как работает описано в Обсуждении)
@return экземпляр класса NSData, закэшированные данные указанного URL
*/
- (NSData *)cachedDataForURL:(NSURL *)url
                 offlineMode:(BOOL)offlineMode;

@end