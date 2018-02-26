### Test for Senior Rails developers:

First of all you should create three models with at minimum the following attributes:

Stock (name: string)
Bearer (name: string)
MarketPrice (currency: string, value_cents: integer)

A bearer can own multiple stocks. Bearers should be unique by name. A market price can be referenced by multiple stocks but should be unique by the combination of currency and price.

Next step is to create some JSON API endpoints:

Via one API endpoint you should be able to create a stock with a referenced bearer and market price.

Another API endpoint should allow to update a stock. Bearer and market price can not be updated but if attributes of either of those change, new objects need to be created and referenced with the existing stock. Name of the stock bearer and currency of the market price should be unique. If an existing bearer or market price exists already, they should be re-used and connected to the stock instead. One stock has one bearer and one market price but bearers and market prices can be connected to multiple stocks.

One simple API endpoint should list all stocks, showing information from connected models, and should only use a maximum of three sql queries (use active record syntax). Although it should be doable in one.

In a last API endpoint it should be possible to soft-delete a stock so it doesn't appear anywhere anymore in regular queries but could still be retrieved when needed by e.g. a BI-department.

Please try to keep your controllers very lean, especially try not to implement the duplication logic (see first API endpoint) in the controllers.

Error responses should be detailed in a way that they explain what exactly is missing or wrong. In order to test this, consider to make validations that forbid names to contain "invalid".

Reflect the explained logic and endpoints in rspec tests.

Bonne chance and feel free to ask questions when you get totally stuck.




**There are such endpoints:**

_Create stock:_ POST /api/v1/stocks

```$xslt
{
	"stock": {
		"name": "Stock name", 
		"bearer_attributes":{
		  "name":"Me"
		}, 
		"market_price_attributes": {
		  "value_cents": 9.39, 
		  "currency": "EUR" 
		}
	}
}
```
_Responce:_ HTTP/1.1 200 OK
```
{
	"id": 1,
	"name": "Stock name",
	"bearer_id": 1,
	"market_price_id": 1,
	"removed": false,
	"created_at": "2018-02-26T10:42:54.954Z",
	"updated_at": "2018-02-26T10:42:54.954Z"
}
```

_Create invalid stock:_ POST /api/v1/stocks

``` 
{
	"name": "invalid", 
	"bearer_attributes": "invalid", 
	"value": 19.39, 
	"currency": "EUR" 
}
```
Responce:_  HTTP/1.1 422 Unprocessable Entity
```
{
	"error": {
		"bearer": [
			"is invalid"
		],
		"market_price": [
			"is invalid"
		],
		"name": [
			"is invalid"
		]
	}
}
```


_Update stock:_ PUT /api/v1/stocks/1

```$xslt
{
	"stock": {
		"name": "Stock updated name",
		"bearer_attributes": {
			"name": "Me"
		},
		"market_price_attributes":{
			"currency": "EUR",
			"value_cents": 4300.00
		}
	}
}
```
_Responce:_ HTTP/1.1 200 OK
```
{
	"name": "Stock updated name",
	"bearer_attributes": {
		"name": "Me"
	},
	"market_price_attributes": {
		"currency": "EUR",
		"value_cents": 4300.0
	}
}
```

_Get all stocks:_ GET /api/v1/stocks

_Responce:_ HTTP/1.1 200 OK
```
[
	{
		"id": 1,
		"name": "Stock updated name",
		"bearer_id": 1,
		"market_price_id": 2,
		"removed": false,
		"created_at": "2018-02-26T09:44:59.085Z",
		"updated_at": "2018-02-26T11:02:32.449Z",
		"bearer": {
			"id": 1,
			"name": "Me",
			"created_at": "2018-02-26T11:02:32.432Z",
			"updated_at": "2018-02-26T11:02:32.432Z"
		},
		"market_price": {
			"id": 2,
			"currency": "EUR",
			"value_cents": 4300.0,
			"created_at": "2018-02-26T11:02:32.438Z",
			"updated_at": "2018-02-26T11:02:32.438Z"
		}
	}
]
```

_Delete stock:_ DELETE /api/v1/stocks/1

_Responce:_ HTTP/1.1 200 OK
```
{
	"removed": true,
	"id": 1,
	"name": "Stock updated name",
	"bearer_id": 1,
	"market_price_id": 2,
	"created_at": "2018-02-26T09:44:59.085Z",
	"updated_at": "2018-02-26T11:08:38.629Z"
}
```