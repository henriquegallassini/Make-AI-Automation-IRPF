CREATE TABLE public.pessoas (
  id bigint NOT NULL DEFAULT nextval('pessoas_id_seq'::regclass),
  nome text NOT NULL,
  cpf text NOT NULL UNIQUE,
  email text,
  telefone text,
  endereco text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT pessoas_pkey PRIMARY KEY (id)
);
CREATE TABLE public.exercicios (
  id bigint NOT NULL DEFAULT nextval('exercicios_id_seq'::regclass),
  pessoa_id bigint NOT NULL,
  ano_base integer NOT NULL,
  status text NOT NULL DEFAULT 'em_coleta'::text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT exercicios_pkey PRIMARY KEY (id),
  CONSTRAINT exercicios_pessoa_id_fkey FOREIGN KEY (pessoa_id) REFERENCES public.pessoas(id)
);
CREATE TABLE public.uploads (
  id bigint NOT NULL DEFAULT nextval('uploads_id_seq'::regclass),
  bucket text NOT NULL DEFAULT 'irpf_documentos'::text,
  path text NOT NULL,
  original_filename text,
  mime_type text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT uploads_pkey PRIMARY KEY (id)
);
CREATE TABLE public.documentos (
  id bigint NOT NULL DEFAULT nextval('documentos_id_seq'::regclass),
  exercicio_id bigint NOT NULL,
  pessoa_id bigint NOT NULL,
  ano_base integer NOT NULL,
  tipo USER-DEFINED NOT NULL,
  instituicao_texto text,
  descricao text,
  upload_id bigint NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT documentos_pkey PRIMARY KEY (id),
  CONSTRAINT documentos_exercicio_id_fkey FOREIGN KEY (exercicio_id) REFERENCES public.exercicios(id),
  CONSTRAINT documentos_pessoa_id_fkey FOREIGN KEY (pessoa_id) REFERENCES public.pessoas(id),
  CONSTRAINT documentos_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES public.uploads(id)
);
CREATE TABLE public.pendencias (
  id bigint NOT NULL DEFAULT nextval('pendencias_id_seq'::regclass),
  exercicio_id bigint NOT NULL,
  pessoa_id bigint NOT NULL,
  ano_base integer NOT NULL,
  tipo USER-DEFINED NOT NULL,
  instituicao_texto text,
  descricao_sugerida text,
  origem USER-DEFINED NOT NULL DEFAULT 'ia'::pendencia_origem,
  status USER-DEFINED NOT NULL DEFAULT 'pendente'::pendencia_status,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  resolvida_em timestamp with time zone,
  CONSTRAINT pendencias_pkey PRIMARY KEY (id),
  CONSTRAINT pendencias_exercicio_id_fkey FOREIGN KEY (exercicio_id) REFERENCES public.exercicios(id),
  CONSTRAINT pendencias_pessoa_id_fkey FOREIGN KEY (pessoa_id) REFERENCES public.pessoas(id)
);
CREATE TABLE public.comunicados_envios (
  id bigint NOT NULL DEFAULT nextval('comunicados_envios_id_seq'::regclass),
  pessoa_id bigint NOT NULL,
  exercicio_id bigint NOT NULL,
  canal text NOT NULL CHECK (canal = ANY (ARRAY['email'::text, 'whatsapp'::text])),
  destinatario text NOT NULL,
  assunto text,
  conteudo text NOT NULL,
  enviado_em timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT comunicados_envios_pkey PRIMARY KEY (id),
  CONSTRAINT comunicados_envios_pessoa_id_fkey FOREIGN KEY (pessoa_id) REFERENCES public.pessoas(id),
  CONSTRAINT comunicados_envios_exercicio_id_fkey FOREIGN KEY (exercicio_id) REFERENCES public.exercicios(id)
);
CREATE TABLE public.irpf_perguntas_respostas (
  id bigint NOT NULL DEFAULT nextval('irpf_perguntas_respostas_id_seq'::regclass),
  pessoa_id bigint,
  exercicio_id bigint,
  ano_base integer,
  cpf_informado text,
  origem text NOT NULL CHECK (origem = ANY (ARRAY['email'::text, 'whatsapp'::text, 'manual'::text, 'webhook'::text])),
  remetente text NOT NULL,
  destinatario text,
  mensagem_externa_id text,
  thread_externa_id text,
  assunto text,
  pergunta text NOT NULL,
  resposta_ia text,
  resposta_final text,
  status text NOT NULL DEFAULT 'recebida'::text CHECK (status = ANY (ARRAY['recebida'::text, 'em_analise_ia'::text, 'aguardando_aprovacao'::text, 'ajustada'::text, 'aprovada'::text, 'rejeitada'::text, 'enviada'::text, 'erro'::text])),
  aprovado_por text,
  aprovado_em timestamp with time zone,
  ajustado_por text,
  ajustado_em timestamp with time zone,
  enviado_em timestamp with time zone,
  erro_mensagem text,
  payload_origem jsonb NOT NULL DEFAULT '{}'::jsonb,
  payload_ia jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT irpf_perguntas_respostas_pkey PRIMARY KEY (id),
  CONSTRAINT irpf_perguntas_respostas_pessoa_id_fkey FOREIGN KEY (pessoa_id) REFERENCES public.pessoas(id),
  CONSTRAINT irpf_perguntas_respostas_exercicio_id_fkey FOREIGN KEY (exercicio_id) REFERENCES public.exercicios(id)
);