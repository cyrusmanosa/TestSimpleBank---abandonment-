# iterm 到在此的File內輸入make "item" ＝》 即可進行

# 建立PSQL
postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

# 建立DB
createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

# 移除DB
dropdb:
	docker exec -it postgres12 dropdb simple_bank

# 將舊DB遷移到新DB
migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

# 將新DB遷移到舊DB
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

# 執行item的變數
.PHONY: postgres createdb dropdb migrateup migratedown sqlc test server 
