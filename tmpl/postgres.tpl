// Code generated by pgxgen. DO NOT EDIT.
package {{.PackageName}}

import (
	"github.com/graph-gophers/dataloader"
    "github.com/jackc/pgx"
    store "{{.ImportPath}}/store"
)

func ToStoreErr(fn string, err error) error {
	if err == nil {
		return nil
	}
    if err == pgx.ErrNoRows {
        return &store.Error{Err: err, Code: store.ErrCodeNotFound, Impl: "{{.PackageName}}", Function: fn}
    }
    if pge, ok := err.(pgx.PgError); ok && pge.Code == "23505" {
        return &store.Error{Err: err, Code: store.ErrCodeDuplicate, Impl: "{{.PackageName}}", Function: fn}
    }
    return &store.Error{Err: err, Code: store.ErrCodeUnknown, Impl: "{{.PackageName}}", Function: fn}
}

type generatedLoaders struct {
{{range .Queries -}}
    {{.Name}} *dataloader.Loader
{{end -}}
}

type PGStore struct {
	generatedLoaders
	conn store.PostgresConnection
}

func New(conn store.PostgresConnection) *PGStore {
    ld := generatedLoaders{
    {{range .Queries -}}
        {{.Name}}: dataloader.NewBatchedLoader(batchFunc{{.Name}}(conn)),
    {{end -}}
    }
    return &PGStore{generatedLoaders: ld, conn: conn}
}