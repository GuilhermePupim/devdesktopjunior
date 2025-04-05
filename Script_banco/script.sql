-- Table: public.TspdCep

-- DROP TABLE IF EXISTS public."TspdCep";
CREATE TABLE IF NOT EXISTS public."TspdCep"
(
    id integer NOT NULL DEFAULT nextval('"TspdCep_id"'::regclass),
    cep character varying(10) COLLATE pg_catalog."default",
    logradouro character varying(255) COLLATE pg_catalog."default",
    complemento character varying(255) COLLATE pg_catalog."default",
    bairro character varying(150) COLLATE pg_catalog."default",
    localidade character varying(150) COLLATE pg_catalog."default",
    uf character(2) COLLATE pg_catalog."default",
    ibge character varying(10) COLLATE pg_catalog."default",
    ddd character varying(3) COLLATE pg_catalog."default",
    CONSTRAINT "TspdCep_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."TspdCep"
    OWNER to postgres;