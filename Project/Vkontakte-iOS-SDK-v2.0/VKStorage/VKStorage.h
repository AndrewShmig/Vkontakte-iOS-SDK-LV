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

/** Основной ключ используемый для хранения информации о токенах доступа содержащихся
в хранилище.
*/
static NSString *const kVKStorageUserDefaultsKey = @"Vkontakte-iOS-SDK-v2.0-Storage";

/** Основная директория для хранения файловых данных используемая в SDK (полный путь представляет
собой конкатенацию директории NSCachesDirectory и этой константы)
*/
static NSString *const kVKStoragePath = @"/Vkontakte-iOS-SDK-v2.0-Storage/";

/** Основная директория для хранения кэша данных используемая в SDK (полный путь представляет
собой конкатенацию директории NSCachesDirectory и этой констаны)
*/
static NSString *const kVKStorageCachePath = @"/Vkontakte-iOS-SDK-v2.0-Storage/Cache/";


@class VKStorageItem;
@class VKAccessToken;

/** Класс представляет собой хранилище для пользовательских токенов доступа и
закэшированных данных.
Основным хранимым элементом является элемент типа VKStorageItem, который содержит
пользовательский токен доступа и связанную с ним директорию для кэша.
*/
@interface VKStorage : NSObject

/**
@name Свойства
*/
/** Является ли хранилище пустым
*/
@property (nonatomic, readonly) BOOL isEmpty;

/** Кол-во элементов находящихся в хранилище
*/
@property (nonatomic, readonly) NSUInteger count;

/** Полный путь к основной директории хранилища
*/
@property (nonatomic, readonly) NSString *fullStoragePath;

/** Полный путь к основной директории кэша хранилища
*/
@property (nonatomic, readonly) NSString *fullCacheStoragePath;

/**
@name Инициализация
*/
/** Общее хранилище

@return экземпляр класс VKStorage
*/
+ (instancetype)sharedStorage;

/**
@name Создание элементов хранилища
*/
/** Создаёт элемент хранилища

@param token пользовательский токен доступа для которого будет создан элемент хранилища
@return экземпляр класс VKStorageItem
*/
- (VKStorageItem *)createStorageItemForAccessToken:(VKAccessToken *)token;

/**
@name Манипулирование данными хранилища
*/
/** Добавляет в хранилище новый элемент

@param item элемент хранилища
*/
- (void)addItem:(VKStorageItem *)item;

/** Удаляет из хранилища указанный элемент

@param item элемент хранилища
*/
- (void)removeItem:(VKStorageItem *)item;

/** Удаляет все данные из хранилища.
*/
- (void)clean;

/** Удаляет все данные кэша в хранилище
*/
- (void)cleanCachedData;

/**
@name Чтение элементов хранилища
*/
/** Получение элемента хранилища по пользовательскому идентификатору

@param userID пользовательский идентификатор
@return экземпляр класса VKStorageItem, либо nil, если элемента в хранилище
*/
- (VKStorageItem *)storageItemForUserID:(NSUInteger)userID;

/** Список всех элементов хранилища

@return массив со всеми элементами хранилища типа VKStorageItem
*/
- (NSArray *)storageItems;

@end