# Testes de API

## Register

### Requisição

```http
POST /v1/users HTTP/1.1
Host: localhost:8080
Content-Type: application/json

{
    "name": "Marcos",
    "email": "m@gmail.com",
    "password": "123456",
    "phone_number": "+5511912345678",
    "role": "user"
}
```

**Melhorias necessárias**
    - Não precisar passar role

### Resposta

```http
HTTP/1.1 500 Internal Server Error
Content-Type: application/json

{"error":"Internal server error","code":"INTERNAL_ERROR"}
```

## Auth

**Falta implementar**
    - Refresh token

### Login

```http
POST /v1/auth/login HTTP/1.1
Host: localhost:8080
Content-Type: application/json

{
    "email": "john.doe@example.com",
    "password": "securepass123"
}
```

### Resposta

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpvaG4uZG9lQGV4YW1wbGUuY29tIiwiZXhwIjoxNzQ5MTcxNTE1LCJpYXQiOjE3NDkxNzA2MTUsInJvbGUiOiJ1c2VyIiwidXNlcl9pZCI6IjAxOTc0MjkxLWM5MjktN2M5ZC1iYTMyLWU1Njc2OTIyOGJmNCJ9.AaGI0o-GufmsICeXwjsF9nm3_oLDGEO1M-DKoyJsfYs",
    "refresh_token": "04b82780-4add-42d5-828a-aa095b3c70d7",
    "expires_in": 900,
    "token_type": "Bearer"
}
```

**Melhorias necessárias**
    - Vir name no token

## Get Transactions


```http
GET /v1/transactions$userId&start_date=${startDate}Z&end_date=${endDate}Z HTTP/1.1
Host: localhost:8080
Content-Type: application/json
```

### Resposta

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
    "status": "success",
    "data": []
}
```

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
    "success": true,
    "data": [
        {
            "id": "019747c5-50a0-71ff-bc69-fa1bd2d73797",
            "user_id": "01974291-c929-7c9d-ba32-e56769228bf4",
            "title": "Uber casa",
            "amount": 2000,
            "type": "expense",
            "category_id": "transport",
            "date": "2025-06-06T21:23:22.979Z",
            "source": "app",
            "created_at": "2025-06-07T00:23:23.040095Z",
            "updated_at": "2025-06-07T00:23:23.040095Z"
        }
    ]
}
```

**Melhorias necessárias**
    - Na categoria, vir um objeto da categoria talvez seja melhor
    - Mudar "title" para "description"

## Get Balance

```http
GET /v1/balance HTTP/1.1
Host: localhost:8080
Content-Type: application/json
```

### Resposta (ROTA NÃO IMPLEMENTADA)


## Post Transaction

```http
POST /v1/transactions HTTP/1.1
Host: localhost:8080
Content-Type: application/json
```

### Requisição

```http
{
    "title": "Uber casa",
    "amount": 2000,
    "category_id": "transport",
    "type": "expense",
    "date": "2025-06-06T21:23:22.979Z",
    "source": "app",
    "user_id": "01974291-c929-7c9d-ba32-e56769228bf4"
}
```

**Melhorias necessárias**
    - Evitar passar user_id
    - Mudar "title" para "description"

### Resposta

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
    "success": true,
    "data": {
        "transaction": {
            "id": "019747c5-50a0-71ff-bc69-fa1bd2d73797",
            "user_id": "01974291-c929-7c9d-ba32-e56769228bf4",
            "title": "Uber casa",
            "amount": 2000,
            "type": "expense",
            "category_id": "transport",
            "date": "2025-06-06T21:23:22.979Z",
            "source": "app",
            "created_at": "2025-06-07T00:23:23.040095964Z",
            "updated_at": "2025-06-07T00:23:23.040095964Z"
        }
    }
}
```

## Edit Transaction (COM PROBLEMA DE CORS)

```http
PUT /v1/transactions/${transactionId}?user_id=${userId} HTTP/1.1
Host: localhost:8080
Content-Type: application/json

{
    "title": "Uber casa",
    "amount": 2000,
    "category_id": "transport",
    "type": "expense",
    "date": "2025-06-06T21:23:22.979Z",
    "source": "app"
}
```

### Resposta

```http
HTTP/1.1 200 OK
Content-Type: application/json

    COM PROBLEMA DE CORS
```

**Melhorias necessárias**
    - Evitar passar user_id na url
    - Mudar "title" para "description"

## Delete Transaction (COM PROBLEMA NO BODY)

```http
DELETE /v1/transactions/${transactionId}?user_id=${userId} HTTP/1.1
Host: localhost:8080
Content-Type: application/json
```

### Resposta

```http
HTTP/1.1 200 OK
Content-Type: application/json

    {"level":"error","timestamp":"2025-06-07T18:57:44.989Z","caller":"response/response.go:36","msg":"Failed to encode JSON response","error":"http: request method or response status code does not allow body"}
```

**Melhorias necessárias**
    - Evitar passar user_id na url

## Categories

```http
GET /v1/categories HTTP/1.1
Host: localhost:8080
Content-Type: application/json
```

### Resposta

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
    "status": "success",
    "data": {success: true, data: [{id: alcohol, name: Alcohol}, {id: clothing, name: Clothing}, {id: communications, name: Communications}, {id: education, name: Education}, {id: financial, name: Financial}, {id: food, name: Food}, {id: health, name: Healthcare}, {id: housing, name: Housing}, {id: leisure, name: Leisure}, {id: misc, name: Miscellaneous}, {id: restaurants, name: Restaurants}, {id: transport, name: Transportation}]}
}
```

**Melhorias necessárias**
    - Ter categorias de "Income" e "Expense" separadas
    - Vir separado por tipo
    - Serem em português
