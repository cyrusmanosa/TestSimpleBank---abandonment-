# iterm 到在此的File內輸入make "item" ＝》 即可進行

# 建立PSQL
dockernetwork:
	docker network create bank-network

# 建立PSQL
postgres:
	docker run --name postgres15.4 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:15.4-alpine

# 建立DB
createdb:
	docker exec -it postgres15.4 createdb --username=root --owner=root simple_bank

# 移除DB
dropdb:
	docker exec -it postgres15.4 dropdb simple_bank
	
# 將舊DB遷移到新DB

#Load 
# migrateup:
#   migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

#AWS
migrateup:
    migrate -path db/migration -database "postgresql://root:kYDoSmiamiorvAIpx7IT@testsimplebank.csnputdh1foj.ap-northeast-3.rds.amazonaws.com:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

# 將新DB遷移到舊DB
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go  github.com/techschool/simplebank/db/sqlc Store

# 執行item的變數
.PHONY: dockernetwork postgres createdb dropdb migrateup migrateup1 migratedown migratedown1 sqlc test server mock
