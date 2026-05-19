--
-- PostgreSQL database dump
--

\restrict QyfNp1MqieiiTGlIAldoT0YzH7o88dYztmtDVVH7nfmIK9xa9P7I7Wnew0eec0r

-- Dumped from database version 14.21
-- Dumped by pg_dump version 14.21

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: app_user
--

CREATE TABLE public.audit_log (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    event_type character varying(50),
    performed_by character varying(100),
    details text,
    description text
);


ALTER TABLE public.audit_log OWNER TO app_user;

--
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: app_user
--

CREATE SEQUENCE public.audit_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_log_id_seq OWNER TO app_user;

--
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_user
--

ALTER SEQUENCE public.audit_log_id_seq OWNED BY public.audit_log.id;


--
-- Name: end_devices; Type: TABLE; Schema: public; Owner: app_user
--

CREATE TABLE public.end_devices (
    dev_eui text NOT NULL,
    location text
);


ALTER TABLE public.end_devices OWNER TO app_user;

--
-- Name: lora_uplink_metadata; Type: TABLE; Schema: public; Owner: app_user
--

CREATE TABLE public.lora_uplink_metadata (
    id integer NOT NULL,
    received_at timestamp with time zone DEFAULT now() NOT NULL,
    device_eui text,
    application_id text,
    gateway_id text,
    frequency_hz bigint,
    bandwidth_hz integer,
    spreading_factor integer,
    rssi_dbm double precision,
    snr_db double precision,
    f_cnt bigint,
    raw_event jsonb
);


ALTER TABLE public.lora_uplink_metadata OWNER TO app_user;

--
-- Name: lora_uplink_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: app_user
--

CREATE SEQUENCE public.lora_uplink_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lora_uplink_metadata_id_seq OWNER TO app_user;

--
-- Name: lora_uplink_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_user
--

ALTER SEQUENCE public.lora_uplink_metadata_id_seq OWNED BY public.lora_uplink_metadata.id;


--
-- Name: pending_recovery; Type: TABLE; Schema: public; Owner: app_user
--

CREATE TABLE public.pending_recovery (
    device_eui text NOT NULL,
    app_id text NOT NULL,
    start_ts bigint NOT NULL,
    end_ts bigint NOT NULL,
    last_requested_at double precision NOT NULL,
    retry_count integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pending_recovery OWNER TO app_user;

--
-- Name: sensor_data; Type: TABLE; Schema: public; Owner: app_user
--

CREATE TABLE public.sensor_data (
    id integer NOT NULL,
    device_timestamp timestamp with time zone NOT NULL,
    server_timestamp timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    device_eui character varying(50),
    ambient_temp numeric(5,2),
    immediate_temp numeric(5,2),
    conductor_temp numeric(5,2),
    cpu_temp numeric(5,2),
    raw_payload text
);


ALTER TABLE public.sensor_data OWNER TO app_user;

--
-- Name: sensor_data_id_seq; Type: SEQUENCE; Schema: public; Owner: app_user
--

CREATE SEQUENCE public.sensor_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sensor_data_id_seq OWNER TO app_user;

--
-- Name: sensor_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app_user
--

ALTER SEQUENCE public.sensor_data_id_seq OWNED BY public.sensor_data.id;


--
-- Name: audit_log id; Type: DEFAULT; Schema: public; Owner: app_user
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN id SET DEFAULT nextval('public.audit_log_id_seq'::regclass);


--
-- Name: lora_uplink_metadata id; Type: DEFAULT; Schema: public; Owner: app_user
--

ALTER TABLE ONLY public.lora_uplink_metadata ALTER COLUMN id SET DEFAULT nextval('public.lora_uplink_metadata_id_seq'::regclass);


--
-- Name: sensor_data id; Type: DEFAULT; Schema: public; Owner: app_user
--

ALTER TABLE ONLY public.sensor_data ALTER COLUMN id SET DEFAULT nextval('public.sensor_data_id_seq'::regclass);


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: app_user
--

COPY public.audit_log (id, created_at, event_type, performed_by, details, description) FROM stdin;
1	2026-05-07 12:07:33.242923+00	SYSTEM_PURGE	mqtt-listener	Role: system | Automated cleanup deleted 0 records.	Automated cleanup deleted 0 records.
2	2026-05-07 12:07:33.283587+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778155333 to 1778155631, Base64: Amn8f0Vp/IBv	Requested retransmission from ac1f09fffe1acbd5: 1778155333 to 1778155631, Base64: Amn8f0Vp/IBv
3	2026-05-07 12:08:38.584334+00	RECOVERY_COMPLETED	mqtt-listener	Role: system | Recovery interval 1778155333-1778155631 completed for ac1f09fffe1acbd5.	Recovery interval 1778155333-1778155631 completed for ac1f09fffe1acbd5.
4	2026-05-07 13:31:19.977325+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778160382 to 1778160500, Base64: Amn8kv5p/JN0	Requested retransmission from ac1f09fffe1acbd5: 1778160382 to 1778160500, Base64: Amn8kv5p/JN0
5	2026-05-07 13:31:20.082854+00	RECOVERY_COMPLETED	mqtt-listener	Role: system | Recovery interval 1778160382-1778160500 completed for ac1f09fffe1acbd5.	Recovery interval 1778160382-1778160500 completed for ac1f09fffe1acbd5.
6	2026-05-07 13:32:01.273573+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778160502 to 1778160621, Base64: Amn8k3Zp/JPt	Requested retransmission from ac1f09fffe1acbd5: 1778160502 to 1778160621, Base64: Amn8k3Zp/JPt
7	2026-05-07 13:32:01.337917+00	RECOVERY_COMPLETED	mqtt-listener	Role: system | Recovery interval 1778160502-1778160621 completed for ac1f09fffe1acbd5.	Recovery interval 1778160502-1778160621 completed for ac1f09fffe1acbd5.
8	2026-05-07 13:32:02.704422+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778160623 to 1778160711, Base64: Amn8k+9p/JRH	Requested retransmission from ac1f09fffe1acbd5: 1778160623 to 1778160711, Base64: Amn8k+9p/JRH
9	2026-05-07 13:32:02.770986+00	RECOVERY_COMPLETED	mqtt-listener	Role: system | Recovery interval 1778160623-1778160711 completed for ac1f09fffe1acbd5.	Recovery interval 1778160623-1778160711 completed for ac1f09fffe1acbd5.
10	2026-05-11 08:27:12.771417+00	MISSING_AUTHENTIK_HEADERS	UNKNOWN	Role: unauthenticated | Request rejected. Path: /api/me	Request rejected. Path: /api/me
11	2026-05-11 08:45:52.31933+00	MISSING_AUTHENTIK_HEADERS	UNKNOWN	Role: unauthenticated | Request rejected. Path: /api/me	Request rejected. Path: /api/me
12	2026-05-11 08:54:12.701235+00	UNAUTHORIZED_GROUP	akadmin	Role: unauthorized | User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']	User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']
13	2026-05-11 08:54:20.364176+00	UNAUTHORIZED_GROUP	akadmin	Role: unauthorized | User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']	User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']
14	2026-05-11 08:54:36.51563+00	UNAUTHORIZED_GROUP	akadmin	Role: unauthorized | User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']	User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']
15	2026-05-11 08:54:39.544186+00	UNAUTHORIZED_GROUP	akadmin	Role: unauthorized | User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']	User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']
16	2026-05-11 08:55:34.12046+00	UNAUTHORIZED_GROUP	AS-adm	Role: unauthorized | User has no API-authorized Authentik group. Groups: ['AS Access']	User has no API-authorized Authentik group. Groups: ['AS Access']
17	2026-05-11 08:57:33.33494+00	UNAUTHORIZED_GROUP	akadmin	Role: unauthorized | User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']	User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']
18	2026-05-11 08:58:49.730649+00	UNAUTHORIZED_GROUP	akadmin	Role: unauthorized | User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']	User has no API-authorized Authentik group. Groups: ['authentik Admins|Grafana Access|NS Access|AS Access']
19	2026-05-11 09:11:09.513258+00	GET_ME	akadmin	Role: admin | User inspected own Authentik-derived API identity	User inspected own Authentik-derived API identity
20	2026-05-11 09:11:20.157368+00	GET_LATEST	akadmin	Role: admin | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
21	2026-05-11 09:11:41.749454+00	GET_HISTORY	akadmin	Role: admin | Retrieved telemetry history. Limit: 10	Retrieved telemetry history. Limit: 10
22	2026-05-11 09:13:34.981959+00	GET_HISTORY	akadmin	Role: admin | Retrieved telemetry history. Limit: 10	Retrieved telemetry history. Limit: 10
23	2026-05-11 09:31:34.526503+00	MISSING_AUTHENTIK_HEADERS	UNKNOWN	Role: unauthenticated | Request rejected. Path: /api/status/latest	Request rejected. Path: /api/status/latest
24	2026-05-11 09:37:11.565013+00	UNAUTHORIZED_ACCESS	NS-adm	Role: ns_admin | Tried to access endpoint requiring one of: ['admin', 'as_admin', 'viewer']	Tried to access endpoint requiring one of: ['admin', 'as_admin', 'viewer']
25	2026-05-11 09:38:02.24108+00	UNAUTHORIZED_ACCESS	NS-adm	Role: ns_admin | Tried to access endpoint requiring one of: ['admin', 'as_admin', 'viewer']	Tried to access endpoint requiring one of: ['admin', 'as_admin', 'viewer']
26	2026-05-11 09:38:30.084187+00	UNAUTHORIZED_ACCESS	NS-adm	Role: ns_admin | Tried to access endpoint requiring one of: ['admin', 'as_admin', 'viewer']	Tried to access endpoint requiring one of: ['admin', 'as_admin', 'viewer']
27	2026-05-11 09:38:46.924794+00	MISSING_AUTHENTIK_HEADERS	UNKNOWN	Role: unauthenticated | Request rejected. Path: /api/status/latest	Request rejected. Path: /api/status/latest
28	2026-05-11 09:38:48.876594+00	UNAUTHORIZED_ACCESS	NS-adm	Role: ns_admin | Tried to access endpoint requiring one of: ['admin', 'as_admin', 'viewer']	Tried to access endpoint requiring one of: ['admin', 'as_admin', 'viewer']
29	2026-05-11 09:39:49.368713+00	MISSING_AUTHENTIK_HEADERS	UNKNOWN	Role: unauthenticated | Request rejected. Path: /api/status/latest	Request rejected. Path: /api/status/latest
30	2026-05-11 09:41:15.776434+00	UNAUTHORIZED_ACCESS	NS-adm	Role: ns_admin | Tried to access endpoint requiring one of: ['admin', 'as_admin']	Tried to access endpoint requiring one of: ['admin', 'as_admin']
31	2026-05-12 10:32:36.774557+00	VIEW_AUDIT	AS-adm	Role: as_admin | Viewed latest audit log entries	Viewed latest audit log entries
32	2026-05-12 10:56:22.086081+00	GET_LATEST	AS-adm	Role: as_admin | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
33	2026-05-12 11:03:36.781586+00	GET_LATEST	AS-adm	Role: as_admin | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
34	2026-05-12 11:03:46.04897+00	GET_HISTORY	AS-adm	Role: as_admin | Retrieved telemetry history. Device: None, start: None, end: None, limit: 100	Retrieved telemetry history. Device: None, start: None, end: None, limit: 100
35	2026-05-12 11:04:46.159516+00	VIEW_AUDIT	AS-adm	Role: as_admin | Viewed latest audit log entries. Limit: 50	Viewed latest audit log entries. Limit: 50
83	2026-05-13 10:07:18.380631+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
36	2026-05-12 11:05:01.399046+00	DATA_PURGE	AS-adm	Role: as_admin | Deleted 0 telemetry rows older than 30 days	Deleted 0 telemetry rows older than 30 days
37	2026-05-12 11:08:13.384672+00	VIEW_AUDIT	AS-adm	Role: as_admin | Viewed latest audit log entries. Limit: 50	Viewed latest audit log entries. Limit: 50
38	2026-05-13 07:40:15.752429+00	SYSTEM_PURGE	mqtt-listener	Role: system | Automated cleanup deleted 0 records.	Automated cleanup deleted 0 records.
39	2026-05-13 07:40:15.987004+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778571593 to 1778657992, Base64: AmoC2UlqBCrI	Requested retransmission from ac1f09fffe1acbd5: 1778571593 to 1778657992, Base64: AmoC2UlqBCrI
40	2026-05-13 07:55:20.835816+00	VIEW_AUDIT	AS-adm	Role: as_admin | Viewed latest audit log entries. Limit: 50	Viewed latest audit log entries. Limit: 50
41	2026-05-13 08:08:50.382133+00	SYSTEM_PURGE	mqtt-listener	Role: system | Automated cleanup deleted 0 records.	Automated cleanup deleted 0 records.
42	2026-05-13 08:13:14.730832+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778573574 to 1778659974, Base64: AmoC4QZqBDKG	Requested retransmission from ac1f09fffe1acbd5: 1778573574 to 1778659974, Base64: AmoC4QZqBDKG
43	2026-05-13 09:13:24.309252+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778573574 to 1778659974, Base64: AmoC4QZqBDKG	Requested retransmission from ac1f09fffe1acbd5: 1778573574 to 1778659974, Base64: AmoC4QZqBDKG
44	2026-05-13 09:14:49.844676+00	VIEW_AUDIT	AS-adm	Role: as_admin | Viewed latest audit log entries. Limit: 10	Viewed latest audit log entries. Limit: 10
45	2026-05-13 09:15:05.665235+00	VIEW_AUDIT	AS-adm	Role: as_admin | Viewed latest audit log entries. Limit: 10	Viewed latest audit log entries. Limit: 10
46	2026-05-13 09:16:34.013764+00	VIEW_AUDIT	AS-adm	Role: as_admin | Viewed latest audit log entries. Limit: 10	Viewed latest audit log entries. Limit: 10
47	2026-05-13 09:18:05.405567+00	MISSING_AUTHENTIK_HEADERS	UNKNOWN	Role: unauthenticated | Request rejected. Path: /api/admin/audit	Request rejected. Path: /api/admin/audit
48	2026-05-13 09:18:11.233357+00	UNAUTHORIZED_ACCESS	AS-user	Role: viewer | Tried to access endpoint requiring one of: ['admin', 'as_admin']	Tried to access endpoint requiring one of: ['admin', 'as_admin']
49	2026-05-13 09:18:22.227547+00	VIEW_AUDIT	AS-adm	Role: as_admin | Viewed latest audit log entries. Limit: 50	Viewed latest audit log entries. Limit: 50
50	2026-05-13 09:23:10.2305+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778577784 to 1778664184, Base64: AmoC8XhqBEL4	Requested retransmission from ac1f09fffe1acbd5: 1778577784 to 1778664184, Base64: AmoC8XhqBEL4
51	2026-05-13 09:33:31.084747+00	SYSTEM_PURGE	mqtt-listener	Role: system | Automated cleanup deleted 0 records.	Automated cleanup deleted 0 records.
52	2026-05-13 10:00:09.478183+00	GET_LATEST	AS-adm	Role: as_admin | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
53	2026-05-13 10:03:02.773986+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
54	2026-05-13 10:05:46.566562+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
55	2026-05-13 10:05:47.750882+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
56	2026-05-13 10:05:49.004869+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
57	2026-05-13 10:05:50.144207+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
58	2026-05-13 10:05:51.312076+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
59	2026-05-13 10:05:52.661115+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
60	2026-05-13 10:05:53.838794+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
61	2026-05-13 10:05:54.998654+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
62	2026-05-13 10:05:56.203322+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
63	2026-05-13 10:05:57.436721+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
64	2026-05-13 10:05:58.58062+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
65	2026-05-13 10:05:59.738376+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
66	2026-05-13 10:06:00.948395+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
67	2026-05-13 10:06:02.048865+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
68	2026-05-13 10:06:03.254405+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
69	2026-05-13 10:06:04.364952+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
70	2026-05-13 10:06:05.472035+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
71	2026-05-13 10:06:06.562799+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
72	2026-05-13 10:06:07.725498+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
73	2026-05-13 10:06:08.908328+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
74	2026-05-13 10:07:08.096748+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
75	2026-05-13 10:07:09.171173+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
76	2026-05-13 10:07:10.311511+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
77	2026-05-13 10:07:11.402852+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
78	2026-05-13 10:07:12.560382+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
79	2026-05-13 10:07:13.75502+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
80	2026-05-13 10:07:14.780816+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
81	2026-05-13 10:07:15.916457+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
82	2026-05-13 10:07:17.181783+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
84	2026-05-13 10:07:19.603094+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
85	2026-05-13 10:07:20.883545+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
86	2026-05-13 10:07:22.097205+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
87	2026-05-13 10:07:23.213582+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
88	2026-05-13 10:07:24.421204+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
89	2026-05-13 10:07:25.591538+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
90	2026-05-13 10:07:26.62686+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
91	2026-05-13 10:07:27.92735+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
92	2026-05-13 10:07:29.037481+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
93	2026-05-13 10:07:30.169639+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
94	2026-05-13 10:12:40.883366+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
95	2026-05-13 10:23:26.600473+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778577784 to 1778664184, Base64: AmoC8XhqBEL4	Requested retransmission from ac1f09fffe1acbd5: 1778577784 to 1778664184, Base64: AmoC8XhqBEL4
96	2026-05-13 10:51:35.210177+00	VIEW_AUDIT	AS-adm	Role: as_admin | Viewed latest audit log entries. Limit: 10	Viewed latest audit log entries. Limit: 10
97	2026-05-13 10:52:04.134108+00	UNAUTHORIZED_ACCESS	AS-user	Role: viewer | Tried to access endpoint requiring one of: ['admin', 'as_admin']	Tried to access endpoint requiring one of: ['admin', 'as_admin']
98	2026-05-13 10:52:23.7376+00	GET_LATEST	AS-user	Role: viewer | Retrieved latest telemetry measurement	Retrieved latest telemetry measurement
99	2026-05-13 10:52:38.427468+00	VIEW_AUDIT	AS-adm	Role: as_admin | Viewed latest audit log entries. Limit: 10	Viewed latest audit log entries. Limit: 10
100	2026-05-13 11:23:29.519195+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778577784 to 1778664184, Base64: AmoC8XhqBEL4	Requested retransmission from ac1f09fffe1acbd5: 1778577784 to 1778664184, Base64: AmoC8XhqBEL4
101	2026-05-14 07:46:11.16731+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778577784 to 1778664184, Base64: AmoC8XhqBEL4	Requested retransmission from ac1f09fffe1acbd5: 1778577784 to 1778664184, Base64: AmoC8XhqBEL4
102	2026-05-14 08:46:14.132308+00	RECOVERY_FAILED	mqtt-listener	Role: system | Recovery failed for ac1f09fffe1acbd5: interval 1778577784-1778664184 was not filled after 3 retries. Giving up.	Recovery failed for ac1f09fffe1acbd5: interval 1778577784-1778664184 was not filled after 3 retries. Giving up.
103	2026-05-14 10:25:09.511494+00	SYSTEM_PURGE	mqtt-listener	Role: system | Automated cleanup deleted 0 records.	Automated cleanup deleted 0 records.
104	2026-05-14 10:25:09.582618+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778754288, Base64: AmoEY2BqBaLw	Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778754288, Base64: AmoEY2BqBaLw
105	2026-05-14 10:57:30.490735+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778756228, Base64: AmoEY2BqBaqE	Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778756228, Base64: AmoEY2BqBaqE
106	2026-05-14 11:20:58.516642+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778757642, Base64: AmoEY2BqBbAK	Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778757642, Base64: AmoEY2BqBbAK
107	2026-05-14 11:58:09.206649+00	MISSING_AUTHENTIK_HEADERS	UNKNOWN	Role: unauthenticated | Request rejected. Path: /api/status/latest	Request rejected. Path: /api/status/latest
108	2026-05-14 12:17:55.88434+00	UNAUTHORIZED_ACCESS	NS-adm	Role: ns_admin | Tried to access endpoint requiring one of: ['admin', 'as_admin', 'viewer']	Tried to access endpoint requiring one of: ['admin', 'as_admin', 'viewer']
109	2026-05-14 12:20:15.677186+00	MISSING_AUTHENTIK_HEADERS	UNKNOWN	Role: unauthenticated | Request rejected. Path: /api/admin/audit	Request rejected. Path: /api/admin/audit
110	2026-05-14 12:21:17.560244+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778757642, Base64: AmoEY2BqBbAK	Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778757642, Base64: AmoEY2BqBbAK
111	2026-05-14 12:21:22.154173+00	UNAUTHORIZED_ACCESS	AS-user	Role: viewer | Tried to access endpoint requiring one of: ['admin', 'as_admin']	Tried to access endpoint requiring one of: ['admin', 'as_admin']
112	2026-05-14 14:04:14.594915+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778757642, Base64: AmoEY2BqBbAK	Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778757642, Base64: AmoEY2BqBbAK
113	2026-05-14 15:04:17.529939+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778757642, Base64: AmoEY2BqBbAK	Requested retransmission from ac1f09fffe1acbd5: 1778672480 to 1778757642, Base64: AmoEY2BqBbAK
114	2026-05-14 17:38:48.043128+00	RECOVERY_FAILED	mqtt-listener	Role: system | Recovery failed for ac1f09fffe1acbd5: interval 1778672480-1778757642 was not filled after 3 retries.	Recovery failed for ac1f09fffe1acbd5: interval 1778672480-1778757642 was not filled after 3 retries.
115	2026-05-15 09:00:26.096536+00	SYSTEM_PURGE	mqtt-listener	Role: system | Automated cleanup deleted 0 records.	Automated cleanup deleted 0 records.
116	2026-05-15 09:00:26.172234+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778835583, Base64: AmoFxptqBuB/	Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778835583, Base64: AmoFxptqBuB/
117	2026-05-15 09:04:06.230392+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778835824, Base64: AmoFxptqBuFw	Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778835824, Base64: AmoFxptqBuFw
118	2026-05-15 09:08:36.487019+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778836094, Base64: AmoFxptqBuJ+	Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778836094, Base64: AmoFxptqBuJ+
119	2026-05-15 09:31:38.10328+00	SYSTEM_PURGE	mqtt-listener	Role: system | Automated cleanup deleted 0 records.	Automated cleanup deleted 0 records.
120	2026-05-15 09:31:38.195235+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778837435, Base64: AmoFxptqBue7	Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778837435, Base64: AmoFxptqBue7
121	2026-05-15 09:56:00.23784+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778837435, Base64: AmoFxptqBue7	Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778837435, Base64: AmoFxptqBue7
122	2026-05-15 09:58:08.574985+00	SYSTEM_PURGE	mqtt-listener	Role: system | Automated cleanup deleted 0 records.	Automated cleanup deleted 0 records.
123	2026-05-15 09:58:08.654692+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778839028, Base64: AmoFxptqBu30	Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778839028, Base64: AmoFxptqBu30
124	2026-05-15 10:03:08.723514+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778839328, Base64: AmoFxptqBu8g	Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778839328, Base64: AmoFxptqBu8g
125	2026-05-15 10:14:00.912653+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778839328, Base64: AmoFxptqBu8g	Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778839328, Base64: AmoFxptqBu8g
126	2026-05-15 10:24:01.356294+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778839328, Base64: AmoFxptqBu8g	Requested retransmission from ac1f09fffe1acbd5: 1778763419 to 1778839328, Base64: AmoFxptqBu8g
127	2026-05-15 10:34:01.809168+00	RECOVERY_FAILED	mqtt-listener	Role: system | Recovery failed for ac1f09fffe1acbd5: interval 1778763419-1778839328 was not filled after 2 retries.	Recovery failed for ac1f09fffe1acbd5: interval 1778763419-1778839328 was not filled after 2 retries.
128	2026-05-15 10:44:14.060892+00	SYSTEM_PURGE	mqtt-listener	Role: system | Automated cleanup deleted 0 records.	Automated cleanup deleted 0 records.
129	2026-05-15 10:44:14.143485+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778839330 to 1778841853, Base64: AmoG7yJqBvj9	Requested retransmission from ac1f09fffe1acbd5: 1778839330 to 1778841853, Base64: AmoG7yJqBvj9
130	2026-05-15 10:55:00.96123+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778839330 to 1778841853, Base64: AmoG7yJqBvj9	Requested retransmission from ac1f09fffe1acbd5: 1778839330 to 1778841853, Base64: AmoG7yJqBvj9
131	2026-05-15 11:05:01.426996+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778839330 to 1778841853, Base64: AmoG7yJqBvj9	Requested retransmission from ac1f09fffe1acbd5: 1778839330 to 1778841853, Base64: AmoG7yJqBvj9
132	2026-05-15 11:07:26.635354+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778839330 to 1778842296, Base64: AmoG7yJqBvq4	Requested retransmission from ac1f09fffe1acbd5: 1778839330 to 1778842296, Base64: AmoG7yJqBvq4
133	2026-05-15 11:12:31.881362+00	JUMP_ANOMALY	mqtt-listener	Role: system | Rejected record from ac1f09fffe1acbd5: Sudden jump detected! Changed 8.61°C over 0.12 min.	Rejected record from ac1f09fffe1acbd5: Sudden jump detected! Changed 8.61°C over 0.12 min.
134	2026-05-15 11:12:31.908083+00	JUMP_ANOMALY	mqtt-listener	Role: system | Rejected record from ac1f09fffe1acbd5: Sudden jump detected! Changed 9.15°C over 0.12 min.	Rejected record from ac1f09fffe1acbd5: Sudden jump detected! Changed 9.15°C over 0.12 min.
135	2026-05-15 11:18:01.930023+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778839330 to 1778842296, Base64: AmoG7yJqBvq4	Requested retransmission from ac1f09fffe1acbd5: 1778839330 to 1778842296, Base64: AmoG7yJqBvq4
136	2026-05-15 11:21:53.823486+00	RECOVERY_COMPLETED	mqtt-listener	Role: system | Recovery interval 1778839330-1778842296 completed for ac1f09fffe1acbd5.	Recovery interval 1778839330-1778842296 completed for ac1f09fffe1acbd5.
137	2026-05-15 11:22:43.761898+00	JUMP_ANOMALY	mqtt-listener	Role: system | Rejected record from ac1f09fffe1acbd5: Sudden jump detected! Changed 9.15°C over 0.38 min.	Rejected record from ac1f09fffe1acbd5: Sudden jump detected! Changed 9.15°C over 0.38 min.
138	2026-05-15 11:34:35.924714+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778843831 to 1778843920, Base64: AmoHALdqBwEQ	Requested retransmission from ac1f09fffe1acbd5: 1778843831 to 1778843920, Base64: AmoHALdqBwEQ
139	2026-05-15 11:35:21.739051+00	RECOVERY_COMPLETED	mqtt-listener	Role: system | Recovery interval 1778843831-1778843920 completed for ac1f09fffe1acbd5.	Recovery interval 1778843831-1778843920 completed for ac1f09fffe1acbd5.
140	2026-05-15 11:40:31.031193+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778843982 to 1778845218, Base64: AmoHAU5qBwYi	Requested retransmission from ac1f09fffe1acbd5: 1778843982 to 1778845218, Base64: AmoHAU5qBwYi
141	2026-05-15 11:51:02.864236+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778843982 to 1778845218, Base64: AmoHAU5qBwYi	Requested retransmission from ac1f09fffe1acbd5: 1778843982 to 1778845218, Base64: AmoHAU5qBwYi
142	2026-05-15 11:51:29.253286+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778843982 to 1778845880, Base64: AmoHAU5qBwi4	Requested retransmission from ac1f09fffe1acbd5: 1778843982 to 1778845880, Base64: AmoHAU5qBwi4
143	2026-05-15 12:02:03.287785+00	RECOVERY_REQUEST	mqtt-listener	Role: system | Requested retransmission from ac1f09fffe1acbd5: 1778843982 to 1778845880, Base64: AmoHAU5qBwi4	Requested retransmission from ac1f09fffe1acbd5: 1778843982 to 1778845880, Base64: AmoHAU5qBwi4
\.


--
-- Data for Name: end_devices; Type: TABLE DATA; Schema: public; Owner: app_user
--

COPY public.end_devices (dev_eui, location) FROM stdin;
ac1f09fffe1acbd5	1
\.


--
-- Data for Name: lora_uplink_metadata; Type: TABLE DATA; Schema: public; Owner: app_user
--

COPY public.lora_uplink_metadata (id, received_at, device_eui, application_id, gateway_id, frequency_hz, bandwidth_hz, spreading_factor, rssi_dbm, snr_db, f_cnt, raw_event) FROM stdin;
2	2026-05-15 11:07:26.592816+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	12	-99	-3	1	{"dr": 0, "adr": true, "data": "agb6uQJhA40LXQwl", "fCnt": 1, "time": "2026-05-15T11:07:26.981566256+00:00", "fPort": 2, "rxInfo": [{"snr": -3.0, "rssi": -99, "gwTime": "2026-05-15T11:07:25.981337+00:00", "nsTime": "2026-05-15T11:07:26.361459629+00:00", "channel": 4, "context": "7GWLmA==", "location": {"altitude": 88.0, "latitude": 56.17145033333333, "longitude": 10.192099833333334}, "uplinkId": 1615525998, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878464.981566256s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 12}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "89c5cfb6-6c5e-4776-8ed6-f1e27244ffd1"}
3	2026-05-15 11:08:09.813576+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	10	-101	-4.25	2	{"dr": 2, "adr": true, "data": "agb62ALNA/kLyQyRagb69gLNA/kLyQyR", "fCnt": 2, "time": "2026-05-15T11:08:10.060749758+00:00", "fPort": 2, "rxInfo": [{"snr": -4.25, "rssi": -101, "gwTime": "2026-05-15T11:08:09.060453+00:00", "nsTime": "2026-05-15T11:08:09.560388500+00:00", "channel": 5, "context": "7vbhdA==", "location": {"altitude": 88.0, "latitude": 56.17145033333333, "longitude": 10.192099833333334}, "uplinkId": 1049800537, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878508.060749758s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 10}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "b2bac418-462d-4d46-b959-f6c67821f5fe"}
4	2026-05-15 11:08:12.052366+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	10	-100	-3.25	3	{"dr": 2, "adr": true, "data": "agbvPwR7BacNdw4/agbvXQSxBd0NrQ51agbvewR7BacNdw4/agbvmQR7BacNdw4/", "fCnt": 3, "time": "2026-05-15T11:08:12.347631829+00:00", "fPort": 2, "rxInfo": [{"snr": -3.25, "rssi": -100, "gwTime": "2026-05-15T11:08:11.347332+00:00", "nsTime": "2026-05-15T11:08:11.811163465+00:00", "channel": 3, "context": "7xnGlA==", "location": {"altitude": 88.0, "latitude": 56.17145033333333, "longitude": 10.192099833333334}, "uplinkId": 3703508370, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878510.347631829s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 10}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "824eff20-a105-471a-9e20-6daba93a14d9"}
5	2026-05-15 11:08:21.991631+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	10	-100	-3	4	{"dr": 2, "adr": true, "data": "agbvtwR7BacNdw4/agbv1QR7BacNdw4/agbv8wR7BacNdw4/agbwEQSxBd0NrQ51", "fCnt": 4, "time": "2026-05-15T11:08:22.352299832+00:00", "fPort": 2, "rxInfo": [{"snr": -3.0, "rssi": -100, "gwTime": "2026-05-15T11:08:21.351984648+00:00", "nsTime": "2026-05-15T11:08:21.722754584+00:00", "channel": 3, "context": "77JvRQ==", "location": {"altitude": 87.0, "latitude": 56.1715205, "longitude": 10.1919875}, "uplinkId": 3063511930, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878520.352299832s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 10}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "3a7baba5-4752-4a13-80c4-1369823b8198"}
6	2026-05-15 11:08:32.122942+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	10	-98	-0.75	5	{"dr": 2, "adr": true, "data": "agbwLwR7BacNdw4/agbwTQR7BacNdw4/agbwawRFBXENQQ4JagbwiQQPBTsNDA3U", "fCnt": 5, "time": "2026-05-15T11:08:32.356724534+00:00", "fPort": 2, "rxInfo": [{"snr": -0.75, "rssi": -98, "gwTime": "2026-05-15T11:08:31.356394+00:00", "nsTime": "2026-05-15T11:08:31.877465242+00:00", "channel": 1, "context": "8EsXAQ==", "rfChain": 1, "location": {"altitude": 87.0, "latitude": 56.1715205, "longitude": 10.1919875}, "uplinkId": 1962076728, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878530.356724534s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 10}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "9af89e38-ac0c-494c-a389-ef96c52c0c55"}
7	2026-05-15 11:08:41.756825+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868500000	125000	9	-98	-0.75	6	{"dr": 3, "adr": true, "data": "agb7FQM4BGQMNAz8agbwpwR7BacNdw4/agbwxQSxBd0NrQ51agbw4wQPBTsNDA3U", "fCnt": 6, "time": "2026-05-15T11:08:42.052915297+00:00", "fPort": 2, "rxInfo": [{"snr": -0.75, "rssi": -98, "gwTime": "2026-05-15T11:08:41.052570947+00:00", "nsTime": "2026-05-15T11:08:41.502335836+00:00", "channel": 2, "context": "8N8Ktw==", "rfChain": 1, "location": {"altitude": 87.0, "latitude": 56.1715205, "longitude": 10.1919875}, "uplinkId": 429490971, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878540.052915297s"}], "txInfo": {"frequency": 868500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "29f38112-226e-4f9f-aaa4-35d16d42b961"}
8	2026-05-15 11:08:51.665463+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	9	-98	-3	7	{"dr": 3, "adr": true, "data": "agbxAgQPBTsNDA3UagbxIAOkBNAMoA1oagbxPgOkBNAMoA1oagbxXAM4BGQMNAz8", "fCnt": 7, "time": "2026-05-15T11:08:52.036935694+00:00", "fPort": 2, "rxInfo": [{"snr": -3.0, "rssi": -98, "gwTime": "2026-05-15T11:08:51.036575999+00:00", "nsTime": "2026-05-15T11:08:51.408348755+00:00", "channel": 6, "context": "8Xdivg==", "location": {"altitude": 89.0, "latitude": 56.171997833333336, "longitude": 10.192085333333333}, "uplinkId": 582539663, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878550.036935694s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "42908a1f-aadc-4905-96bc-5cd3325a4320"}
9	2026-05-15 11:09:01.658169+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	9	-99	-2.75	8	{"dr": 3, "adr": true, "data": "agbxegLNA/kLyQyRagbxmALNA/kLyQyRagbxtgLNA/kLyQyRagbx1AKXA8MLkwxb", "fCnt": 8, "time": "2026-05-15T11:09:02.042825028+00:00", "fPort": 2, "rxInfo": [{"snr": -2.75, "rssi": -99, "gwTime": "2026-05-15T11:09:01.042450+00:00", "nsTime": "2026-05-15T11:09:01.415442928+00:00", "channel": 7, "context": "8hAQNA==", "location": {"altitude": 89.0, "latitude": 56.171997833333336, "longitude": 10.192085333333333}, "uplinkId": 815030019, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878560.042825028s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "e8984a0e-819f-46bb-94ab-57e24e43dc93"}
10	2026-05-15 11:09:11.659123+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	9	-99	-4.25	9	{"dr": 3, "adr": true, "data": "agb7MwNuBJoMag0yagbx8gLNA/kLyQyRagbyEAKXA8MLkwxbagbyLgJhA40LXQwl", "fCnt": 9, "time": "2026-05-15T11:09:12.047232312+00:00", "fPort": 2, "rxInfo": [{"snr": -4.25, "rssi": -99, "gwTime": "2026-05-15T11:09:11.046841953+00:00", "nsTime": "2026-05-15T11:09:11.416251132+00:00", "channel": 4, "context": "8qi34Q==", "location": {"altitude": 89.0, "latitude": 56.171997833333336, "longitude": 10.192085333333333}, "uplinkId": 521340674, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878570.047232312s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "f7e8f7cd-86a1-44ad-92ff-677d0d7b5bee"}
11	2026-05-15 11:09:21.66456+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	9	-112	-6.25	10	{"dr": 3, "adr": true, "data": "agbyTAKXA8MLkwxbagbyagJhA40LXQwlagbyiAIrA1cLJwvvagbypwJhA40LXQwl", "fCnt": 10, "time": "2026-05-15T11:09:22.051750698+00:00", "fPort": 2, "rxInfo": [{"snr": -6.25, "rssi": -112, "gwTime": "2026-05-15T11:09:21.051344999+00:00", "nsTime": "2026-05-15T11:09:21.427725464+00:00", "channel": 6, "context": "80Ff+g==", "location": {"altitude": 89.0, "latitude": 56.171997833333336, "longitude": 10.192085333333333}, "uplinkId": 4000545780, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878580.051750698s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "ae877414-6c13-4eca-84b0-7d958920b4fa"}
12	2026-05-15 11:09:31.659308+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-100	-3.5	11	{"dr": 3, "adr": true, "data": "agbyxQIrA1cLJwvvagby4wJhA40LXQwlagbzAQKXA8MLkwxbagbzHwLNA/kLyQyR", "fCnt": 11, "time": "2026-05-15T11:09:32.056152043+00:00", "fPort": 2, "rxInfo": [{"snr": -3.5, "rssi": -100, "gwTime": "2026-05-15T11:09:31.055730999+00:00", "nsTime": "2026-05-15T11:09:31.423203058+00:00", "channel": 3, "context": "89oHoA==", "location": {"altitude": 89.0, "latitude": 56.171997833333336, "longitude": 10.192085333333333}, "uplinkId": 1025377091, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878590.056152043s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "44797811-24a0-4a14-862d-019734217654"}
13	2026-05-15 11:09:41.657855+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	9	-99	-2.75	12	{"dr": 3, "adr": true, "data": "agb7UQNuBJoMag0yagbzPQLNA/kLyQyRagbzWwMDBC8L/wzHagbzeQMDBC8L/wzH", "fCnt": 12, "time": "2026-05-15T11:09:42.060440319+00:00", "fPort": 2, "rxInfo": [{"snr": -2.75, "rssi": -99, "gwTime": "2026-05-15T11:09:41.060003939+00:00", "nsTime": "2026-05-15T11:09:41.430457199+00:00", "channel": 4, "context": "9HKu1g==", "location": {"altitude": 89.0, "latitude": 56.171997833333336, "longitude": 10.192085333333333}, "uplinkId": 634934616, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878600.060440319s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "5c36b71d-a9f2-4ad4-978b-8953664cf8f4"}
14	2026-05-15 11:09:51.684482+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-101	-3.25	13	{"dr": 3, "adr": true, "data": "agbzlwM4BGQMNAz8agbztQNuBJoMag0yagbz0wOkBNAMoA1oagbz8QOkBNAMoA1o", "fCnt": 13, "time": "2026-05-15T11:09:52.066062196+00:00", "fPort": 2, "rxInfo": [{"snr": -3.25, "rssi": -101, "gwTime": "2026-05-15T11:09:51.065608934+00:00", "nsTime": "2026-05-15T11:09:51.439368820+00:00", "channel": 1, "context": "9QtbPg==", "rfChain": 1, "location": {"altitude": 89.0, "latitude": 56.171997833333336, "longitude": 10.192085333333333}, "uplinkId": 3845978947, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878610.066062196s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "88f4feab-77f5-4096-9694-f3c2009d473b"}
15	2026-05-15 11:10:01.659045+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-98	-1.5	14	{"dr": 3, "adr": true, "data": "agb0DwPaBQYM1g2eagb0LQQPBTsNDA3Uagb0SwQPBTsNDA3Uagb0aQRFBXENQQ4J", "fCnt": 14, "time": "2026-05-15T11:10:02.070687597+00:00", "fPort": 2, "rxInfo": [{"snr": -1.5, "rssi": -98, "gwTime": "2026-05-15T11:10:01.070219+00:00", "nsTime": "2026-05-15T11:10:01.436692846+00:00", "channel": 1, "context": "9aQDww==", "rfChain": 1, "location": {"altitude": 89.0, "latitude": 56.171997833333336, "longitude": 10.192085333333333}, "uplinkId": 3349319635, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878620.070687597s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "68c469be-35f5-45c0-aab0-64f696a6e099"}
16	2026-05-15 11:10:11.682493+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	9	-100	-1.75	15	{"dr": 3, "adr": true, "data": "agb7bwOkBNAMoA1oagb0hwR7BacNdw4/agb0pQR7BacNdw4/agb0wwSxBd0NrQ51", "fCnt": 15, "time": "2026-05-15T11:10:12.075208942+00:00", "fPort": 2, "rxInfo": [{"snr": -1.75, "rssi": -100, "gwTime": "2026-05-15T11:10:11.074725+00:00", "nsTime": "2026-05-15T11:10:11.440525213+00:00", "channel": 6, "context": "9jyr4Q==", "location": {"altitude": 89.0, "latitude": 56.171997833333336, "longitude": 10.192085333333333}, "uplinkId": 2446795025, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878630.075208942s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "4ec4acda-ae37-41f5-86f9-1bcc5afcfcb9"}
17	2026-05-15 11:10:21.747563+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	9	-101	-3.25	16	{"dr": 3, "adr": true, "data": "agb04QSxBd0NrQ51agb0/wTnBhMN4w6ragb1HQTnBhMN4w6ragb1OwUdBkkOGQ7h", "fCnt": 16, "time": "2026-05-15T11:10:22.079773279+00:00", "fPort": 2, "rxInfo": [{"snr": -3.25, "rssi": -101, "gwTime": "2026-05-15T11:10:21.079274+00:00", "nsTime": "2026-05-15T11:10:21.495216412+00:00", "context": "9tVUKg==", "rfChain": 1, "location": {"altitude": 89.0, "latitude": 56.171507166666665, "longitude": 10.191962666666667}, "uplinkId": 383442821, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878640.079773279s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "25751f5c-fcf6-4fbd-a771-e515829db90b"}
18	2026-05-15 11:10:31.704765+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-100	-3.75	17	{"dr": 3, "adr": true, "data": "agb1WQVSBn4OTg8Wagb1dwVSBn4OTg8Wagb1lgVSBn4OTg8Wagb1tAWIBrQOhA9M", "fCnt": 17, "time": "2026-05-15T11:10:32.083221518+00:00", "fPort": 2, "rxInfo": [{"snr": -3.75, "rssi": -100, "gwTime": "2026-05-15T11:10:31.083706916+00:00", "nsTime": "2026-05-15T11:10:31.461257201+00:00", "channel": 5, "context": "9237/w==", "location": {"altitude": 89.0, "latitude": 56.171507166666665, "longitude": 10.191962666666667}, "uplinkId": 3691195887, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878650.083221518s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "71dbb64a-7202-49bb-b8ef-4907312d15c8"}
19	2026-05-15 11:10:41.700628+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	9	-100	-3	18	{"dr": 3, "adr": true, "data": "agb7jQOkBNAMoA1oagb10gWIBrQOhA9Magb18AWIBrQOhA9Magb2DgWIBrQOhA9M", "fCnt": 18, "time": "2026-05-15T11:10:42.087750931+00:00", "fPort": 2, "rxInfo": [{"snr": -3.0, "rssi": -100, "gwTime": "2026-05-15T11:10:41.088221+00:00", "nsTime": "2026-05-15T11:10:41.462052057+00:00", "channel": 6, "context": "+AakJA==", "location": {"altitude": 89.0, "latitude": 56.171507166666665, "longitude": 10.191962666666667}, "uplinkId": 1956712067, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878660.087750931s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "1fda9abc-e0ff-42d5-993d-b26ce522ee0f"}
20	2026-05-15 11:11:01.702892+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	9	-100	-3	20	{"dr": 3, "adr": true, "data": "agb2pAW+BuoOug+Cagb2wgW+BuoOug+Cagb24AW+BuoOug+Cagb2/gX0ByAO8A+4", "fCnt": 20, "time": "2026-05-15T11:11:02.096774462+00:00", "fPort": 2, "rxInfo": [{"snr": -3.0, "rssi": -100, "gwTime": "2026-05-15T11:11:01.097213902+00:00", "nsTime": "2026-05-15T11:11:01.467385216+00:00", "channel": 4, "context": "+Tf0TQ==", "location": {"altitude": 106.0, "latitude": 56.171685333333336, "longitude": 10.191909333333333}, "uplinkId": 2352225018, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878680.096774462s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "422461b0-f0b0-4896-a7a9-09c41a9a80a0"}
21	2026-05-15 11:11:11.739987+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	9	-109	-10.75	21	{"dr": 3, "adr": true, "data": "agb7qwOkBNAMoA1oagb3HAX0ByAO8A+4agb3OgW+BuoOug+Cagb3WAYqB1YPJg/u", "fCnt": 21, "time": "2026-05-15T11:11:12.101442788+00:00", "fPort": 2, "rxInfo": [{"snr": -10.75, "rssi": -109, "gwTime": "2026-05-15T11:11:11.101866898+00:00", "nsTime": "2026-05-15T11:11:11.478866143+00:00", "context": "+dCc/g==", "rfChain": 1, "location": {"altitude": 106.0, "latitude": 56.171685333333336, "longitude": 10.191909333333333}, "uplinkId": 3113179611, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878690.101442788s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "7c27e4cb-cf73-4e78-82c7-86ebb217d3a9"}
22	2026-05-15 11:11:21.731234+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-105	-7.75	22	{"dr": 3, "adr": true, "data": "agb3dgYqB1YPJg/uagb3lAYqB1YPJg/uagb3sgYqB1YPJg/uagb30AYqB1YPJg/u", "fCnt": 22, "time": "2026-05-15T11:11:22.105951225+00:00", "fPort": 2, "rxInfo": [{"snr": -7.75, "rssi": -105, "gwTime": "2026-05-15T11:11:21.106360+00:00", "nsTime": "2026-05-15T11:11:21.481679421+00:00", "channel": 1, "context": "+mlFDg==", "rfChain": 1, "location": {"altitude": 133.0, "latitude": 56.17182616666667, "longitude": 10.191786666666667}, "uplinkId": 933646060, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878700.105951225s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "769bf180-6909-4c03-acfa-7709bb4f2c0c"}
23	2026-05-15 11:11:31.92872+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	9	-102	-4.75	23	{"dr": 3, "adr": true, "data": "agb37gYqB1YPJg/uagb4DAYqB1YPJg/uagb4KgZfB4sPWxAjagb4SAZfB4sPWxAj", "fCnt": 23, "time": "2026-05-15T11:11:32.110381579+00:00", "fPort": 2, "rxInfo": [{"snr": -4.75, "rssi": -102, "gwTime": "2026-05-15T11:11:31.110775+00:00", "nsTime": "2026-05-15T11:11:31.691811178+00:00", "channel": 7, "context": "+wHs0Q==", "location": {"altitude": 133.0, "latitude": 56.17182616666667, "longitude": 10.191786666666667}, "uplinkId": 2273685621, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878710.110381579s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "95e3d66f-efe2-433b-a19f-4ec2f33ebf95"}
24	2026-05-15 11:11:51.745091+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-101	-4.25	25	{"dr": 3, "adr": true, "data": "agb4wAaVB8EPkRBZagb43wbLB/cPxxCPagb4/QbLB/cPxxCPagb5GwcBCC0P/RDF", "fCnt": 25, "time": "2026-05-15T11:11:52.120643249+00:00", "fPort": 2, "rxInfo": [{"snr": -4.25, "rssi": -101, "gwTime": "2026-05-15T11:11:51.121006+00:00", "nsTime": "2026-05-15T11:11:51.494126099+00:00", "channel": 5, "context": "/DNBzw==", "location": {"altitude": 144.0, "latitude": 56.171884666666664, "longitude": 10.191873333333334}, "uplinkId": 4290269476, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878730.120643249s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "7640c229-1b68-4912-9f2d-58f2f0c90a09"}
25	2026-05-15 11:12:01.735417+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	9	-102	-4	26	{"dr": 3, "adr": true, "data": "agb5OQcBCC0P/RDFagb5VwcBCC0P/RDFagb5dQcBCC0P/RDFagb5kwbLB/cPxxCP", "fCnt": 26, "time": "2026-05-15T11:12:02.125081590+00:00", "fPort": 2, "rxInfo": [{"snr": -4.0, "rssi": -102, "gwTime": "2026-05-15T11:12:01.125429+00:00", "nsTime": "2026-05-15T11:12:01.498163757+00:00", "channel": 6, "context": "/Mvpmg==", "location": {"altitude": 144.0, "latitude": 56.171884666666664, "longitude": 10.191873333333334}, "uplinkId": 1496146828, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878740.125081590s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "1f1a62da-1e3b-4768-aa7a-abb448b96a79"}
26	2026-05-15 11:12:11.85749+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-102	-4	27	{"dr": 3, "adr": true, "data": "agb75wNuBJoMag0yagb5sQcBCC0P/RDFagb5zwcBCC0P/RDFagb57QaVB8EPkRBZ", "fCnt": 27, "time": "2026-05-15T11:12:12.129546799+00:00", "fPort": 2, "rxInfo": [{"snr": -4.0, "rssi": -102, "gwTime": "2026-05-15T11:12:11.129878870+00:00", "nsTime": "2026-05-15T11:12:11.603343877+00:00", "channel": 3, "context": "/WSRgA==", "location": {"altitude": 144.0, "latitude": 56.171884666666664, "longitude": 10.191873333333334}, "uplinkId": 1291593453, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878750.129546799s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "576c4b3e-eb9a-4df8-a7ea-dc15f6159218"}
27	2026-05-15 11:12:21.785448+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-98	-6.75	28	{"dr": 3, "adr": true, "data": "agb6CwYqB1YPJg/uagb6KQYqB1YPJg/uagb6RwX0ByAO8A+4agb6ZQW+BuoOug+C", "fCnt": 28, "time": "2026-05-15T11:12:22.154554268+00:00", "fPort": 2, "rxInfo": [{"snr": -6.75, "rssi": -98, "gwTime": "2026-05-15T11:12:21.154871+00:00", "nsTime": "2026-05-15T11:12:21.527046012+00:00", "channel": 3, "context": "/f2Jow==", "location": {"altitude": 151.0, "latitude": 56.17189666666667, "longitude": 10.191813833333333}, "uplinkId": 87455865, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878760.154554268s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "444f9f76-f90f-4f40-b57d-2e6d775b80b6"}
28	2026-05-15 11:12:31.831475+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	9	-100	-2.75	29	{"dr": 3, "adr": true, "data": "agb6fAIrA1cLJwvvagb6gwWIBrQOhA9Magb6mgH1AyIK8gu6agb6oQWIBrQOhA9M", "fCnt": 29, "time": "2026-05-15T11:12:32.158837448+00:00", "fPort": 2, "rxInfo": [{"snr": -2.75, "rssi": -100, "gwTime": "2026-05-15T11:12:31.159138840+00:00", "nsTime": "2026-05-15T11:12:31.594389066+00:00", "context": "/pYw0w==", "rfChain": 1, "location": {"altitude": 151.0, "latitude": 56.17189666666667, "longitude": 10.191813833333333}, "uplinkId": 3430918721, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878770.158837448s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "5d18b8eb-b958-438d-9420-79de433f6024"}
29	2026-05-15 11:13:13.657944+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-101	-3.75	30	{"dr": 3, "adr": true, "data": "agb8BQOkBNAMoA1oagb8IwM4BGQMNAz8", "fCnt": 30, "time": "2026-05-15T11:13:14.036637477+00:00", "fPort": 2, "rxInfo": [{"snr": -3.75, "rssi": -101, "gwTime": "2026-05-15T11:13:13.036875963+00:00", "nsTime": "2026-05-15T11:13:13.401383403+00:00", "channel": 1, "context": "ARUxzA==", "rfChain": 1, "location": {"altitude": 151.0, "latitude": 56.17183883333333, "longitude": 10.191828833333334}, "uplinkId": 2548584213, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878812.036637477s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "5c536b9f-dc4b-4a4f-a73f-3cdf9dce8d23"}
30	2026-05-15 11:13:57.728483+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	9	-101	-3	31	{"dr": 3, "adr": true, "data": "agb8QQLNA/kLyQyR", "fCnt": 31, "time": "2026-05-15T11:13:57.996720072+00:00", "fPort": 2, "rxInfo": [{"snr": -3.0, "rssi": -101, "gwTime": "2026-05-15T11:13:56.996891+00:00", "nsTime": "2026-05-15T11:13:57.482082773+00:00", "channel": 7, "context": "A7P4qg==", "location": {"altitude": 134.0, "latitude": 56.171655333333334, "longitude": 10.1918205}, "uplinkId": 1778733807, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878855.996720072s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "d0430474-ed12-483a-bba2-0e9fab4880e1"}
31	2026-05-15 11:14:41.716068+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	9	-102	-5	32	{"dr": 3, "adr": true, "data": "agb8XwJhA40LXQwlagb8fQJhA40LXQwl", "fCnt": 32, "time": "2026-05-15T11:14:42.086911068+00:00", "fPort": 2, "rxInfo": [{"snr": -5.0, "rssi": -102, "gwTime": "2026-05-15T11:14:41.087013+00:00", "nsTime": "2026-05-15T11:14:41.456426381+00:00", "channel": 7, "context": "BlS7xQ==", "location": {"altitude": 134.0, "latitude": 56.171655333333334, "longitude": 10.1918205}, "uplinkId": 962822607, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878900.086911068s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "eaecea54-04a2-4424-b0ed-bc9aced174cd"}
32	2026-05-15 11:15:25.729972+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-102	-4.5	33	{"dr": 3, "adr": true, "data": "agb8mwJhA40LXQwl", "fCnt": 33, "time": "2026-05-15T11:15:26.047225953+00:00", "fPort": 2, "rxInfo": [{"snr": -4.5, "rssi": -102, "gwTime": "2026-05-15T11:15:25.047261952+00:00", "nsTime": "2026-05-15T11:15:25.469494393+00:00", "channel": 5, "context": "CPODkA==", "location": {"altitude": 134.0, "latitude": 56.171655333333334, "longitude": 10.1918205}, "uplinkId": 1051587749, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878944.047225953s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "2cc542f5-d7d0-4db7-b9a6-3dc73922999c"}
33	2026-05-15 11:16:09.833854+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	9	-100	-3.75	34	{"dr": 3, "adr": true, "data": "agb8uQJhA40LXQwlagb81wKXA8MLkwxb", "fCnt": 34, "time": "2026-05-15T11:16:10.137816898+00:00", "fPort": 2, "rxInfo": [{"snr": -3.75, "rssi": -100, "gwTime": "2026-05-15T11:16:09.137783862+00:00", "nsTime": "2026-05-15T11:16:09.577973232+00:00", "channel": 6, "context": "C5RIOg==", "location": {"altitude": 134.0, "latitude": 56.171655333333334, "longitude": 10.1918205}, "uplinkId": 780813304, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462878988.137816898s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "2905f14c-5241-49e5-943c-db1cac403049"}
34	2026-05-15 11:16:53.722177+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-102	-4.25	35	{"dr": 3, "adr": true, "data": "agb89QLNA/kLyQyR", "fCnt": 35, "time": "2026-05-15T11:16:54.100038383+00:00", "fPort": 2, "rxInfo": [{"snr": -4.25, "rssi": -102, "gwTime": "2026-05-15T11:16:53.099937900+00:00", "nsTime": "2026-05-15T11:16:53.468159408+00:00", "channel": 3, "context": "DjMXdQ==", "location": {"altitude": 134.0, "latitude": 56.171655333333334, "longitude": 10.1918205}, "uplinkId": 4087265552, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879032.100038383s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "ebe1cab5-14b4-4ce2-807e-11772e44132c"}
35	2026-05-15 11:17:37.746944+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	9	-101	-3.75	36	{"dr": 3, "adr": true, "data": "agb9EwJhA40LXQwl", "fCnt": 36, "time": "2026-05-15T11:17:38.122662011+00:00", "fPort": 2, "rxInfo": [{"snr": -3.75, "rssi": -101, "gwTime": "2026-05-15T11:17:37.122494+00:00", "nsTime": "2026-05-15T11:17:37.511601045+00:00", "channel": 4, "context": "ENLSoQ==", "location": {"altitude": 134.0, "latitude": 56.171655333333334, "longitude": 10.1918205}, "uplinkId": 3012617262, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879076.122662011s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "d2bb32e6-deb0-4cf6-95cd-77aef19fe329"}
36	2026-05-15 11:18:21.794744+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-101	-3.25	37	{"dr": 3, "adr": true, "data": "agb9MQJhA40LXQwlagb9TwJhA40LXQwl", "fCnt": 37, "time": "2026-05-15T11:18:22.210234528+00:00", "fPort": 2, "rxInfo": [{"snr": -3.25, "rssi": -101, "gwTime": "2026-05-15T11:18:21.209999+00:00", "nsTime": "2026-05-15T11:18:21.571624753+00:00", "channel": 1, "context": "E3OLgg==", "rfChain": 1, "location": {"altitude": 145.0, "latitude": 56.171757, "longitude": 10.191816166666667}, "uplinkId": 4017390931, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879120.210234528s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "e318b378-3d80-43a4-82f0-6cbf43db447b"}
37	2026-05-15 11:18:23.552596+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-101	-3.75	38	{"dr": 3, "adr": true, "data": "agbvPwR7BacNdw4/agbvXQSxBd0NrQ51agbvewR7BacNdw4/agbvmQR7BacNdw4/", "fCnt": 38, "time": "2026-05-15T11:18:23.934316062+00:00", "fPort": 2, "rxInfo": [{"snr": -3.75, "rssi": -101, "gwTime": "2026-05-15T11:18:22.934079+00:00", "nsTime": "2026-05-15T11:18:23.303873854+00:00", "channel": 1, "context": "E43aMg==", "rfChain": 1, "location": {"altitude": 145.0, "latitude": 56.171757, "longitude": 10.191816166666667}, "uplinkId": 963496061, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879121.934316062s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "66f7f506-4947-499d-9a97-f8494d8f2493"}
38	2026-05-15 11:18:33.60979+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	9	-100	-3.5	39	{"dr": 3, "adr": true, "data": "agbvtwR7BacNdw4/agbv1QR7BacNdw4/agbv8wR7BacNdw4/agbwEQSxBd0NrQ51", "fCnt": 39, "time": "2026-05-15T11:18:33.938863917+00:00", "fPort": 2, "rxInfo": [{"snr": -3.5, "rssi": -100, "gwTime": "2026-05-15T11:18:32.938613061+00:00", "nsTime": "2026-05-15T11:18:33.371965652+00:00", "channel": 6, "context": "FCaCbg==", "location": {"altitude": 145.0, "latitude": 56.171757, "longitude": 10.191816166666667}, "uplinkId": 1777851772, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879131.938863917s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "5e19cc34-459b-4d76-b73e-085d0db21476"}
39	2026-05-15 11:18:53.558085+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-101	-4.25	41	{"dr": 3, "adr": true, "data": "agbwiQQPBTsNDA3UagbwpwR7BacNdw4/agbwxQSxBd0NrQ51agbw4wQPBTsNDA3U", "fCnt": 41, "time": "2026-05-15T11:18:53.950109602+00:00", "fPort": 2, "rxInfo": [{"snr": -4.25, "rssi": -101, "gwTime": "2026-05-15T11:18:52.949826525+00:00", "nsTime": "2026-05-15T11:18:53.311487073+00:00", "channel": 5, "context": "FVfbQQ==", "location": {"altitude": 146.0, "latitude": 56.17180033333333, "longitude": 10.191912}, "uplinkId": 232878453, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879151.950109602s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "7f93181b-e590-497c-b6b9-7116c2b944a7"}
40	2026-05-15 11:19:03.5783+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-114	-6	42	{"dr": 3, "adr": true, "data": "agbxAgQPBTsNDA3UagbxIAOkBNAMoA1oagbxPgOkBNAMoA1oagbxXAM4BGQMNAz8", "fCnt": 42, "time": "2026-05-15T11:19:03.954620461+00:00", "fPort": 2, "rxInfo": [{"snr": -6.0, "rssi": -114, "gwTime": "2026-05-15T11:19:02.954322045+00:00", "nsTime": "2026-05-15T11:19:03.322168769+00:00", "channel": 5, "context": "FfCDVQ==", "location": {"altitude": 146.0, "latitude": 56.17180033333333, "longitude": 10.191912}, "uplinkId": 2495652468, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879161.954620461s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "71f1e2c2-fe54-4d02-9586-2327faae6d5d"}
41	2026-05-15 11:19:13.659545+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868500000	125000	9	-102	-4.25	43	{"dr": 3, "adr": true, "data": "agb9iwJhA40LXQwlagbxegLNA/kLyQyRagbxmALNA/kLyQyRagbxtgLNA/kLyQyR", "fCnt": 43, "time": "2026-05-15T11:19:13.957443751+00:00", "fPort": 2, "rxInfo": [{"snr": -4.25, "rssi": -102, "gwTime": "2026-05-15T11:19:12.957130+00:00", "nsTime": "2026-05-15T11:19:13.410539882+00:00", "channel": 2, "context": "Fokkzw==", "rfChain": 1, "location": {"altitude": 146.0, "latitude": 56.17180033333333, "longitude": 10.191912}, "uplinkId": 1490965706, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879171.957443751s"}], "txInfo": {"frequency": 868500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "6917e819-52c7-42f3-8b94-741e840ad8de"}
42	2026-05-15 11:19:23.574564+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-101	-4	44	{"dr": 3, "adr": true, "data": "agbx1AKXA8MLkwxbagbx8gLNA/kLyQyRagbyEAKXA8MLkwxbagbyLgJhA40LXQwl", "fCnt": 44, "time": "2026-05-15T11:19:23.963853083+00:00", "fPort": 2, "rxInfo": [{"snr": -4.0, "rssi": -101, "gwTime": "2026-05-15T11:19:22.963524+00:00", "nsTime": "2026-05-15T11:19:23.341100246+00:00", "channel": 3, "context": "FyHUTQ==", "location": {"altitude": 146.0, "latitude": 56.17180033333333, "longitude": 10.191912}, "uplinkId": 3333505137, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879181.963853083s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "3a56b7c8-bd1d-4fd4-b268-4b6c2409cc4d"}
43	2026-05-15 11:19:33.614943+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	9	-102	-3.25	45	{"dr": 3, "adr": true, "data": "agbyTAKXA8MLkwxbagbyagJhA40LXQwlagbyiAIrA1cLJwvvagbypwJhA40LXQwl", "fCnt": 45, "time": "2026-05-15T11:19:33.969198544+00:00", "fPort": 2, "rxInfo": [{"snr": -3.25, "rssi": -102, "gwTime": "2026-05-15T11:19:32.968854+00:00", "nsTime": "2026-05-15T11:19:33.377226669+00:00", "context": "F7p/og==", "rfChain": 1, "location": {"altitude": 146.0, "latitude": 56.17180033333333, "longitude": 10.191912}, "uplinkId": 2872616283, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879191.969198544s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "59308b4c-3274-413f-be75-c8d468af0918"}
44	2026-05-15 11:19:43.667339+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-103	-4	46	{"dr": 3, "adr": true, "data": "agb9qQIrA1cLJwvvagbyxQIrA1cLJwvvagby4wJhA40LXQwlagbzAQKXA8MLkwxb", "fCnt": 46, "time": "2026-05-15T11:19:43.975490946+00:00", "fPort": 2, "rxInfo": [{"snr": -4.0, "rssi": -103, "gwTime": "2026-05-15T11:19:42.975131024+00:00", "nsTime": "2026-05-15T11:19:43.412277060+00:00", "channel": 1, "context": "GFMurA==", "rfChain": 1, "location": {"altitude": 146.0, "latitude": 56.17180033333333, "longitude": 10.191912}, "uplinkId": 2567730543, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879201.975490946s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "01eb30dd-9227-4c9e-9314-cd9132d1411f"}
45	2026-05-15 11:19:53.589131+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	9	-102	-4	47	{"dr": 3, "adr": true, "data": "agbzHwLNA/kLyQyRagbzPQLNA/kLyQyRagbzWwMDBC8L/wzHagbzeQMDBC8L/wzH", "fCnt": 47, "time": "2026-05-15T11:19:53.982013279+00:00", "fPort": 2, "rxInfo": [{"snr": -4.0, "rssi": -102, "gwTime": "2026-05-15T11:19:52.981638+00:00", "nsTime": "2026-05-15T11:19:53.352298127+00:00", "channel": 7, "context": "GOvemQ==", "location": {"altitude": 83.0, "latitude": 56.17139816666667, "longitude": 10.1919935}, "uplinkId": 473539751, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879211.982013279s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "d5fa41a2-f6a7-42ef-a94a-7465da2c582e"}
46	2026-05-15 11:20:03.632044+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	9	-102	-4	48	{"dr": 3, "adr": true, "data": "agbzlwM4BGQMNAz8agbztQNuBJoMag0yagbz0wOkBNAMoA1oagbz8QOkBNAMoA1o", "fCnt": 48, "time": "2026-05-15T11:20:03.986418640+00:00", "fPort": 2, "rxInfo": [{"snr": -4.0, "rssi": -102, "gwTime": "2026-05-15T11:20:02.986028013+00:00", "nsTime": "2026-05-15T11:20:03.379779896+00:00", "context": "GYSGRA==", "rfChain": 1, "location": {"altitude": 83.0, "latitude": 56.17139816666667, "longitude": 10.1919935}, "uplinkId": 2828420382, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879221.986418640s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "5fd78926-faf1-47cf-b95e-23251004472a"}
47	2026-05-15 11:20:13.606312+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	9	-100	-3.75	49	{"dr": 3, "adr": true, "data": "agb9xwH1AyIK8gu6agb0DwPaBQYM1g2eagb0LQQPBTsNDA3Uagb0SwQPBTsNDA3U", "fCnt": 49, "time": "2026-05-15T11:20:13.990938969+00:00", "fPort": 2, "rxInfo": [{"snr": -3.75, "rssi": -100, "gwTime": "2026-05-15T11:20:12.990533+00:00", "nsTime": "2026-05-15T11:20:13.363172466+00:00", "channel": 4, "context": "Gh0uXw==", "location": {"altitude": 83.0, "latitude": 56.17139816666667, "longitude": 10.1919935}, "uplinkId": 1841865617, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879231.990938969s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "306cf1a1-7406-4cce-9b53-21e50608d70e"}
48	2026-05-15 11:20:23.60147+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-101	-5.25	50	{"dr": 3, "adr": true, "data": "agb0aQRFBXENQQ4Jagb0hwR7BacNdw4/agb0pQR7BacNdw4/agb0wwSxBd0NrQ51", "fCnt": 50, "time": "2026-05-15T11:20:23.997448311+00:00", "fPort": 2, "rxInfo": [{"snr": -5.25, "rssi": -101, "gwTime": "2026-05-15T11:20:22.997027002+00:00", "nsTime": "2026-05-15T11:20:23.366672744+00:00", "channel": 5, "context": "GrXeQg==", "location": {"altitude": 70.0, "latitude": 56.1713145, "longitude": 10.192036}, "uplinkId": 1037611638, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879241.997448311s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "c8a5a087-a1dd-49e4-96f1-4eb75351a45d"}
49	2026-05-15 11:20:33.626791+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-99	-5.75	51	{"dr": 3, "adr": true, "data": "agb04QSxBd0NrQ51agb0/wTnBhMN4w6ragb1HQTnBhMN4w6ragb1OwUdBkkOGQ7h", "fCnt": 51, "time": "2026-05-15T11:20:34.001925650+00:00", "fPort": 2, "rxInfo": [{"snr": -5.75, "rssi": -99, "gwTime": "2026-05-15T11:20:33.001489+00:00", "nsTime": "2026-05-15T11:20:33.372808262+00:00", "channel": 3, "context": "G06GMg==", "location": {"altitude": 70.0, "latitude": 56.1713145, "longitude": 10.192036}, "uplinkId": 284612585, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879252.001925650s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "2aa09098-885a-4d93-b88f-f0c9f884a34e"}
50	2026-05-15 11:20:43.607945+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	9	-101	-2.75	52	{"dr": 3, "adr": true, "data": "agb95QIrA1cLJwvvagb1WQVSBn4OTg8Wagb1dwVSBn4OTg8Wagb1lgVSBn4OTg8W", "fCnt": 52, "time": "2026-05-15T11:20:44.003860989+00:00", "fPort": 2, "rxInfo": [{"snr": -2.75, "rssi": -101, "gwTime": "2026-05-15T11:20:43.003408999+00:00", "nsTime": "2026-05-15T11:20:43.366799724+00:00", "channel": 4, "context": "G+ckNQ==", "location": {"altitude": 70.0, "latitude": 56.1713145, "longitude": 10.192036}, "uplinkId": 2588735391, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879262.003860989s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "8c82bb25-6eaf-40d4-8b5d-768c9eda8894"}
51	2026-05-15 11:20:53.596868+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	9	-103	-5	53	{"dr": 3, "adr": true, "data": "agb1tAWIBrQOhA9Magb10gWIBrQOhA9Magb18AWIBrQOhA9Magb2DgWIBrQOhA9M", "fCnt": 53, "time": "2026-05-15T11:20:54.008585334+00:00", "fPort": 2, "rxInfo": [{"snr": -5.0, "rssi": -103, "gwTime": "2026-05-15T11:20:53.008118+00:00", "nsTime": "2026-05-15T11:20:53.373410908+00:00", "context": "HH/NHg==", "rfChain": 1, "location": {"altitude": 63.0, "latitude": 56.17126733333333, "longitude": 10.192028166666667}, "uplinkId": 1554507353, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879272.008585334s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "741b8290-0a48-4089-b9f0-1b431e27b3e7"}
52	2026-05-15 11:21:03.724919+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-103	-6	54	{"dr": 3, "adr": true, "data": "agb2LAW+BuoOug+Cagb2SgW+BuoOug+Cagb2aAW+BuoOug+Cagb2hgW+BuoOug+C", "fCnt": 54, "time": "2026-05-15T11:21:04.011974677+00:00", "fPort": 2, "rxInfo": [{"snr": -6.0, "rssi": -103, "gwTime": "2026-05-15T11:21:03.011492+00:00", "nsTime": "2026-05-15T11:21:03.488055772+00:00", "channel": 1, "context": "HRhwzw==", "rfChain": 1, "location": {"altitude": 63.0, "latitude": 56.17126733333333, "longitude": 10.192028166666667}, "uplinkId": 882461217, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879282.011974677s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "efd8d94e-1c29-46b1-b8ec-035e1ca0b6ca"}
53	2026-05-15 11:21:13.67666+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	9	-101	-3.75	55	{"dr": 3, "adr": true, "data": "agb+BAJhA40LXQwlagb2pAW+BuoOug+Cagb2wgW+BuoOug+Cagb24AW+BuoOug+C", "fCnt": 55, "time": "2026-05-15T11:21:14.016420002+00:00", "fPort": 2, "rxInfo": [{"snr": -3.75, "rssi": -101, "gwTime": "2026-05-15T11:21:13.015921984+00:00", "nsTime": "2026-05-15T11:21:13.420437428+00:00", "channel": 6, "context": "HbEYog==", "location": {"altitude": 63.0, "latitude": 56.17126733333333, "longitude": 10.192028166666667}, "uplinkId": 111923906, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879292.016420002s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "bc80b0a9-e4ed-4c3c-b1e5-1e06838fedeb"}
54	2026-05-15 11:21:23.7+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	9	-103	-4	56	{"dr": 3, "adr": true, "data": "agb2/gX0ByAO8A+4agb3HAX0ByAO8A+4agb3OgW+BuoOug+Cagb3WAYqB1YPJg/u", "fCnt": 56, "time": "2026-05-15T11:21:24.019844342+00:00", "fPort": 2, "rxInfo": [{"snr": -4.0, "rssi": -103, "gwTime": "2026-05-15T11:21:23.020330979+00:00", "nsTime": "2026-05-15T11:21:23.457220998+00:00", "context": "HknAXg==", "rfChain": 1, "location": {"altitude": 59.0, "latitude": 56.17123933333333, "longitude": 10.1920205}, "uplinkId": 2085430358, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879302.019844342s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "f422a745-f5a8-4069-8935-e2c7f25d0763"}
55	2026-05-15 11:21:33.639255+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	9	-101	-4	57	{"dr": 3, "adr": true, "data": "agb3dgYqB1YPJg/uagb3lAYqB1YPJg/uagb3sgYqB1YPJg/uagb30AYqB1YPJg/u", "fCnt": 57, "time": "2026-05-15T11:21:34.024290717+00:00", "fPort": 2, "rxInfo": [{"snr": -4.0, "rssi": -101, "gwTime": "2026-05-15T11:21:33.024761999+00:00", "nsTime": "2026-05-15T11:21:33.410603502+00:00", "channel": 4, "context": "HuJoLw==", "location": {"altitude": 59.0, "latitude": 56.17123933333333, "longitude": 10.1920205}, "uplinkId": 2689126149, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879312.024290717s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "ed313dd0-4fed-4ea3-9067-c1779ef3ac31"}
56	2026-05-15 11:21:43.652783+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-101	-4.5	58	{"dr": 3, "adr": true, "data": "agb+IgIrA1cLJwvvagb37gYqB1YPJg/uagb4DAYqB1YPJg/uagb4KgZfB4sPWxAj", "fCnt": 58, "time": "2026-05-15T11:21:44.028805078+00:00", "fPort": 2, "rxInfo": [{"snr": -4.5, "rssi": -101, "gwTime": "2026-05-15T11:21:43.029260999+00:00", "nsTime": "2026-05-15T11:21:43.395876979+00:00", "channel": 5, "context": "H3sQRQ==", "location": {"altitude": 59.0, "latitude": 56.17123933333333, "longitude": 10.1920205}, "uplinkId": 442506896, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879322.028805078s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "253d559b-03f8-44f2-84d2-ecc32b153935"}
57	2026-05-15 11:21:53.716995+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-102	-4.75	59	{"dr": 3, "adr": true, "data": "agb4SAZfB4sPWxAjagb4ZgaVB8EPkRBZagb4hAaVB8EPkRBZagb4ogbLB/cPxxCP", "fCnt": 59, "time": "2026-05-15T11:21:54.033188455+00:00", "fPort": 2, "rxInfo": [{"snr": -4.75, "rssi": -102, "gwTime": "2026-05-15T11:21:53.033628999+00:00", "nsTime": "2026-05-15T11:21:53.461800275+00:00", "channel": 3, "context": "IBO32A==", "location": {"altitude": 53.0, "latitude": 56.171186166666665, "longitude": 10.192022833333333}, "uplinkId": 457432049, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879332.033188455s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "09e2519e-4781-4132-a5a4-3d962ec329aa"}
58	2026-05-15 11:22:03.634169+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-102	-7.25	60	{"dr": 3, "adr": true, "data": "agb4wAaVB8EPkRBZagb43wbLB/cPxxCPagb4/QbLB/cPxxCPagb5GwcBCC0P/RDF", "fCnt": 60, "time": "2026-05-15T11:22:04.039799793+00:00", "fPort": 2, "rxInfo": [{"snr": -7.25, "rssi": -102, "gwTime": "2026-05-15T11:22:03.040224959+00:00", "nsTime": "2026-05-15T11:22:03.406280081+00:00", "channel": 3, "context": "IKxoIQ==", "location": {"altitude": 53.0, "latitude": 56.171186166666665, "longitude": 10.192022833333333}, "uplinkId": 1530097383, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879342.039799793s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "d7a7294d-0690-45b2-a837-e5dc18bca0fa"}
59	2026-05-15 11:22:13.662821+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-102	-4.5	61	{"dr": 3, "adr": true, "data": "agb+QAH1AyIK8gu6agb5OQcBCC0P/RDFagb5VwcBCC0P/RDFagb5dQcBCC0P/RDF", "fCnt": 61, "time": "2026-05-15T11:22:14.044405180+00:00", "fPort": 2, "rxInfo": [{"snr": -4.5, "rssi": -102, "gwTime": "2026-05-15T11:22:13.044814955+00:00", "nsTime": "2026-05-15T11:22:13.407640189+00:00", "channel": 1, "context": "IUUQkg==", "rfChain": 1, "location": {"altitude": 53.0, "latitude": 56.171186166666665, "longitude": 10.192022833333333}, "uplinkId": 3656062304, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879352.044405180s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "27fd12b1-c6e8-4943-8a20-9623b94bc72f"}
60	2026-05-15 11:22:33.66819+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	9	-103	-3.5	63	{"dr": 3, "adr": true, "data": "agb6CwYqB1YPJg/uagb6KQYqB1YPJg/uagb6RwX0ByAO8A+4agb6ZQW+BuoOug+C", "fCnt": 63, "time": "2026-05-15T11:22:34.055469012+00:00", "fPort": 2, "rxInfo": [{"snr": -3.5, "rssi": -103, "gwTime": "2026-05-15T11:22:33.055847999+00:00", "nsTime": "2026-05-15T11:22:33.428648510+00:00", "channel": 7, "context": "InZosA==", "location": {"altitude": 39.0, "latitude": 56.1711215, "longitude": 10.192157166666666}, "uplinkId": 1666390147, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879372.055469012s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "e46c94a4-b192-41c7-9074-e04ac79d9457"}
61	2026-05-15 11:22:43.684458+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	9	-101	-2.5	64	{"dr": 3, "adr": true, "data": "agb+XgH1AyIK8gu6agb6fAIrA1cLJwvvagb6gwWIBrQOhA9Magb6mgH1AyIK8gu6", "fCnt": 64, "time": "2026-05-15T11:22:44.060017952+00:00", "fPort": 2, "rxInfo": [{"snr": -2.5, "rssi": -101, "gwTime": "2026-05-15T11:22:43.060380+00:00", "nsTime": "2026-05-15T11:22:43.431705430+00:00", "channel": 7, "context": "Iw8Q5w==", "location": {"altitude": 39.0, "latitude": 56.1711215, "longitude": 10.192157166666666}, "uplinkId": 4197945565, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879382.060017952s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "0a8c4637-5e2d-4a6d-8e9d-1858927a4b60"}
62	2026-05-15 11:22:53.6046+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-102	-5.5	65	{"dr": 3, "adr": true, "data": "agb6oQWIBrQOhA9M", "fCnt": 65, "time": "2026-05-15T11:22:53.891017814+00:00", "fPort": 2, "rxInfo": [{"snr": -5.5, "rssi": -102, "gwTime": "2026-05-15T11:22:52.891366+00:00", "nsTime": "2026-05-15T11:22:53.363473880+00:00", "channel": 5, "context": "I6UTNA==", "location": {"altitude": 22.0, "latitude": 56.17103816666667, "longitude": 10.192252}, "uplinkId": 746034248, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879391.891017814s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "1a905963-ab1b-4e90-a7aa-eb0bb33c59e4"}
63	2026-05-15 11:23:35.600739+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-99	-6.5	66	{"dr": 3, "adr": true, "data": "agb+fAH1AyIK8gu6", "fCnt": 66, "time": "2026-05-15T11:23:35.898704570+00:00", "fPort": 2, "rxInfo": [{"snr": -6.5, "rssi": -99, "gwTime": "2026-05-15T11:23:34.898988101+00:00", "nsTime": "2026-05-15T11:23:35.345419051+00:00", "channel": 5, "context": "JiYPiA==", "location": {"altitude": 15.0, "latitude": 56.170988, "longitude": 10.192235666666667}, "uplinkId": 1764481672, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879433.898704570s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "4625f1c1-4232-43c5-af2b-222ece7f92d0"}
64	2026-05-15 11:24:19.590668+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-101	-2.5	67	{"dr": 3, "adr": true, "data": "agb+mgHAAuwKvAuEagb+uAH1AyIK8gu6", "fCnt": 67, "time": "2026-05-15T11:24:19.986801249+00:00", "fPort": 2, "rxInfo": [{"snr": -2.5, "rssi": -101, "gwTime": "2026-05-15T11:24:18.987017012+00:00", "nsTime": "2026-05-15T11:24:19.350438375+00:00", "channel": 3, "context": "KMbKcg==", "location": {"altitude": 37.0, "latitude": 56.17112816666667, "longitude": 10.192099833333334}, "uplinkId": 2954252665, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879477.986801249s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "8dcbfad9-630f-4d72-b222-7a3caa1151a0"}
65	2026-05-15 11:25:03.764047+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-102	-3.5	68	{"dr": 3, "adr": true, "data": "agb+1gH1AyIK8gu6", "fCnt": 68, "time": "2026-05-15T11:25:03.947100142+00:00", "fPort": 2, "rxInfo": [{"snr": -3.5, "rssi": -102, "gwTime": "2026-05-15T11:25:02.947248+00:00", "nsTime": "2026-05-15T11:25:03.513181147+00:00", "channel": 3, "context": "K2WSJA==", "location": {"altitude": 41.0, "latitude": 56.17115666666667, "longitude": 10.192077833333334}, "uplinkId": 1036650921, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879521.947100142s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "558235c6-0e90-47ff-8aa0-93a82e5e1756"}
66	2026-05-15 11:25:47.686805+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	9	-102	-3	69	{"dr": 3, "adr": true, "data": "agb+9AJhA40LXQwlagb/EgJhA40LXQwl", "fCnt": 69, "time": "2026-05-15T11:25:48.038121025+00:00", "fPort": 2, "rxInfo": [{"snr": -3.0, "rssi": -102, "gwTime": "2026-05-15T11:25:47.038200961+00:00", "nsTime": "2026-05-15T11:25:47.432157302+00:00", "context": "LgZYew==", "rfChain": 1, "location": {"altitude": 66.0, "latitude": 56.1712635, "longitude": 10.1919325}, "uplinkId": 144715273, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879566.038121025s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "0f4d6c9e-d8da-4f96-8b5e-515bfce8e48c"}
67	2026-05-15 11:26:31.719243+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-103	-4.5	70	{"dr": 3, "adr": true, "data": "agb/MALNA/kLyQyR", "fCnt": 70, "time": "2026-05-15T11:26:31.997642086+00:00", "fPort": 2, "rxInfo": [{"snr": -4.5, "rssi": -103, "gwTime": "2026-05-15T11:26:30.997654002+00:00", "nsTime": "2026-05-15T11:26:31.474724872+00:00", "channel": 1, "context": "MKUdJA==", "rfChain": 1, "location": {"altitude": 66.0, "latitude": 56.171274833333335, "longitude": 10.191939}, "uplinkId": 1463642704, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879609.997642086s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "87576114-2d57-415e-83ee-b6429537416b"}
68	2026-05-15 11:27:15.714914+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	9	-103	-3.5	71	{"dr": 3, "adr": true, "data": "agb/TgLNA/kLyQyRagb/bAKXA8MLkwxb", "fCnt": 71, "time": "2026-05-15T11:27:16.086264685+00:00", "fPort": 2, "rxInfo": [{"snr": -3.5, "rssi": -103, "gwTime": "2026-05-15T11:27:15.086207+00:00", "nsTime": "2026-05-15T11:27:15.467289704+00:00", "channel": 7, "context": "M0XaGA==", "location": {"altitude": 57.0, "latitude": 56.17123383333333, "longitude": 10.191985666666667}, "uplinkId": 3548905572, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879654.086264685s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "33747691-ba93-4ab1-bf4c-715517dbedb1"}
69	2026-05-15 11:27:59.647419+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	9	-103	-4.25	72	{"dr": 3, "adr": true, "data": "agb/igLNA/kLyQyR", "fCnt": 72, "time": "2026-05-15T11:28:00.045874187+00:00", "fPort": 2, "rxInfo": [{"snr": -4.25, "rssi": -103, "gwTime": "2026-05-15T11:27:59.045749999+00:00", "nsTime": "2026-05-15T11:27:59.410334016+00:00", "channel": 7, "context": "NeSfGg==", "location": {"altitude": 42.0, "latitude": 56.171152166666666, "longitude": 10.192080166666667}, "uplinkId": 3314640653, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879698.045874187s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "d551c61c-212f-49e6-a108-31cb0d1a8638"}
70	2026-05-15 11:28:43.723221+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-101	-9.5	73	{"dr": 3, "adr": true, "data": "agb/qALNA/kLyQyRagb/xgNuBJoMag0y", "fCnt": 73, "time": "2026-05-15T11:28:44.134265822+00:00", "fPort": 2, "rxInfo": [{"snr": -9.5, "rssi": -101, "gwTime": "2026-05-15T11:28:43.134072+00:00", "nsTime": "2026-05-15T11:28:43.501793637+00:00", "channel": 5, "context": "OIVbKA==", "location": {"altitude": 34.0, "latitude": 56.171083333333335, "longitude": 10.192068666666668}, "uplinkId": 169847705, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879742.134265822s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "89cdc29e-07d1-4932-b0b0-f8b4028533b5"}
71	2026-05-15 11:29:27.701036+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	9	-103	-4.75	74	{"dr": 3, "adr": true, "data": "agb/5AOkBNAMoA1o", "fCnt": 74, "time": "2026-05-15T11:29:28.093632885+00:00", "fPort": 2, "rxInfo": [{"snr": -4.75, "rssi": -103, "gwTime": "2026-05-15T11:29:27.093371+00:00", "nsTime": "2026-05-15T11:29:27.458387805+00:00", "channel": 6, "context": "OyQfNw==", "location": {"altitude": 32.0, "latitude": 56.171118, "longitude": 10.192157833333333}, "uplinkId": 3825567678, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879786.093632885s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "6ee6ea7f-8ddf-4fac-b42f-b7cd86789b31"}
72	2026-05-15 11:30:11.756996+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	9	-103	-4.5	75	{"dr": 3, "adr": true, "data": "agcAAgOkBNAMoA1oagcAIAOkBNAMoA1o", "fCnt": 75, "time": "2026-05-15T11:30:12.181663995+00:00", "fPort": 2, "rxInfo": [{"snr": -4.5, "rssi": -103, "gwTime": "2026-05-15T11:30:11.181334+00:00", "nsTime": "2026-05-15T11:30:11.541158110+00:00", "channel": 3, "context": "PcTZ3Q==", "location": {"altitude": 20.0, "latitude": 56.17105816666667, "longitude": 10.192168}, "uplinkId": 745931313, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879830.181663995s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "d6e5c3e3-4f88-4196-baff-78d089a8f7d5"}
73	2026-05-15 11:30:55.751555+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	9	-103	-5.25	76	{"dr": 3, "adr": true, "data": "agcAPgOkBNAMoA1o", "fCnt": 76, "time": "2026-05-15T11:30:56.141262055+00:00", "fPort": 2, "rxInfo": [{"snr": -5.25, "rssi": -103, "gwTime": "2026-05-15T11:30:55.140864+00:00", "nsTime": "2026-05-15T11:30:55.501672219+00:00", "channel": 4, "context": "QGOe0g==", "location": {"altitude": 36.0, "latitude": 56.17116466666667, "longitude": 10.192147333333333}, "uplinkId": 4197305597, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879874.141262055s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "44062007-9838-4984-8eb7-c607ba86641a"}
74	2026-05-15 11:31:39.777631+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	9	-104	-5.75	77	{"dr": 3, "adr": true, "data": "agcAXAM4BGQMNAz8", "fCnt": 77, "time": "2026-05-15T11:31:40.164712994+00:00", "fPort": 2, "rxInfo": [{"snr": -5.75, "rssi": -104, "gwTime": "2026-05-15T11:31:39.164246835+00:00", "nsTime": "2026-05-15T11:31:39.537939887+00:00", "channel": 1, "context": "QwNdNQ==", "rfChain": 1, "location": {"altitude": 47.0, "latitude": 56.171203166666665, "longitude": 10.192088666666667}, "uplinkId": 5839786, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879918.164712994s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "811e085d-64b1-4dc4-9d8c-e5c041f3ea45"}
75	2026-05-15 11:32:23.856107+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868500000	125000	9	-102	-2.5	78	{"dr": 3, "adr": true, "data": "agcAegM4BGQMNAz8agcAmAM4BGQMNAz8", "fCnt": 78, "time": "2026-05-15T11:32:24.249806350+00:00", "fPort": 2, "rxInfo": [{"snr": -2.5, "rssi": -102, "gwTime": "2026-05-15T11:32:23.250272+00:00", "nsTime": "2026-05-15T11:32:23.615827109+00:00", "channel": 2, "context": "RaQQSA==", "rfChain": 1, "location": {"altitude": 52.0, "latitude": 56.171241, "longitude": 10.192098333333334}, "uplinkId": 1334877414, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462879962.249806350s"}], "txInfo": {"frequency": 868500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "16629b36-41f3-4aae-8134-106b1cc6f168"}
76	2026-05-15 11:33:07.798219+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	9	-104	-4.5	79	{"dr": 3, "adr": true, "data": "agcAtgNuBJoMag0y", "fCnt": 79, "time": "2026-05-15T11:33:08.209698600+00:00", "fPort": 2, "rxInfo": [{"snr": -4.5, "rssi": -104, "gwTime": "2026-05-15T11:33:07.210096+00:00", "nsTime": "2026-05-15T11:33:07.571260379+00:00", "channel": 7, "context": "SELWYw==", "location": {"altitude": 9.0, "latitude": 56.17108116666667, "longitude": 10.192359166666666}, "uplinkId": 1440681018, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880006.209698600s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "b351e587-4136-431f-b3be-3856c364a312"}
77	2026-05-15 11:34:35.851006+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	9	-103	-5	81	{"dr": 3, "adr": true, "data": "agcBEQMDBC8L/wzH", "fCnt": 81, "time": "2026-05-15T11:34:36.258449941+00:00", "fPort": 2, "rxInfo": [{"snr": -5.0, "rssi": -103, "gwTime": "2026-05-15T11:34:35.258711+00:00", "nsTime": "2026-05-15T11:34:35.616583773+00:00", "channel": 5, "context": "TYJaYA==", "location": {"altitude": 32.0, "latitude": 56.1710695, "longitude": 10.192144333333333}, "uplinkId": 3211783590, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880094.258449941s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "a5109573-b827-45a1-8b57-72ef9a46b5e0"}
78	2026-05-15 11:35:19.955733+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	9	-104	-4.25	82	{"dr": 3, "adr": true, "data": "agcBLwM4BGQMNAz8agcBTQMDBC8L/wzH", "fCnt": 82, "time": "2026-05-15T11:35:20.348539087+00:00", "fPort": 2, "rxInfo": [{"snr": -4.25, "rssi": -104, "gwTime": "2026-05-15T11:35:19.348732+00:00", "nsTime": "2026-05-15T11:35:19.715839649+00:00", "channel": 6, "context": "UCMdEA==", "location": {"altitude": 58.0, "latitude": 56.171291333333336, "longitude": 10.192094833333334}, "uplinkId": 1896123094, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880138.348539087s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "f66a4a62-37db-48c5-ae5f-043a70731341"}
79	2026-05-15 11:35:21.664506+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868500000	125000	9	-103	-4.25	83	{"dr": 3, "adr": true, "data": "agcA1QNuBJoMag0yagcA8wOkBNAMoA1o", "fCnt": 83, "time": "2026-05-15T11:35:22.064511119+00:00", "fPort": 2, "rxInfo": [{"snr": -4.25, "rssi": -103, "gwTime": "2026-05-15T11:35:21.064700935+00:00", "nsTime": "2026-05-15T11:35:21.426757538+00:00", "channel": 2, "context": "UD1MEg==", "rfChain": 1, "location": {"altitude": 58.0, "latitude": 56.171291333333336, "longitude": 10.192094833333334}, "uplinkId": 3173515177, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880140.064511119s"}], "txInfo": {"frequency": 868500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 9}}}, "devAddr": "002a6b34", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "1da9a798-2cea-48a8-ac16-b13eb638d80a"}
80	2026-05-15 11:40:30.952243+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	12	-77	7.5	1	{"dr": 0, "adr": true, "data": "agcGIwIrA1cLJwvv", "fCnt": 1, "time": "2026-05-15T11:40:31.337316887+00:00", "fPort": 2, "rxInfo": [{"snr": 7.5, "rssi": -77, "gwTime": "2026-05-15T11:40:30.337027+00:00", "nsTime": "2026-05-15T11:40:30.709331268+00:00", "channel": 3, "context": "YqxrYg==", "location": {"altitude": 18.0, "latitude": 56.17129666666666, "longitude": 10.192313666666667}, "uplinkId": 1152541069, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880449.337316887s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 12}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "50079f9f-ac09-48e3-af3d-073c284c6618"}
81	2026-05-15 11:41:13.567868+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	7	-78	12.75	2	{"dr": 5, "adr": true, "data": "agcGQQLNA/kLyQyR", "fCnt": 2, "time": "2026-05-15T11:41:13.951778114+00:00", "fPort": 2, "rxInfo": [{"snr": 12.75, "rssi": -78, "gwTime": "2026-05-15T11:41:12.951423+00:00", "nsTime": "2026-05-15T11:41:13.314760638+00:00", "channel": 3, "context": "ZTap6A==", "location": {"altitude": 29.0, "latitude": 56.17121016666667, "longitude": 10.1922385}, "uplinkId": 3626087523, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880491.951778114s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "62d5953d-9a8f-4a7d-bf7d-e47be94730cf"}
82	2026-05-15 11:41:14.878162+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	7	-83	11.75	3	{"dr": 5, "adr": true, "data": "agcBVQH1AyIK8gu6agcGBAH1AyIK8gu6", "fCnt": 3, "time": "2026-05-15T11:41:15.278058221+00:00", "fPort": 2, "rxInfo": [{"snr": 11.75, "rssi": -83, "gwTime": "2026-05-15T11:41:14.277700+00:00", "nsTime": "2026-05-15T11:41:14.634576966+00:00", "context": "ZUrmrQ==", "rfChain": 1, "location": {"altitude": 29.0, "latitude": 56.17121016666667, "longitude": 10.1922385}, "uplinkId": 993783921, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880493.278058221s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "2e618bb1-93f7-4fc5-bfd3-275669e2ab34"}
83	2026-05-15 11:41:56.871111+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	7	-89	8	4	{"dr": 5, "adr": true, "data": "agcGYAM4BGQMNAz8agcGfgOkBNAMoA1o", "fCnt": 4, "time": "2026-05-15T11:41:57.283369481+00:00", "fPort": 2, "rxInfo": [{"snr": 8.0, "rssi": -89, "gwTime": "2026-05-15T11:41:56.282946+00:00", "nsTime": "2026-05-15T11:41:56.644696114+00:00", "channel": 1, "context": "Z8vZtQ==", "rfChain": 1, "location": {"altitude": 45.0, "latitude": 56.17118716666667, "longitude": 10.192144166666667}, "uplinkId": 1925597789, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880535.283369481s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "337bf90e-95f6-4168-8681-bc2c75eafc77"}
84	2026-05-15 11:42:40.890734+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	7	-92	5.5	5	{"dr": 5, "adr": true, "data": "agcGnARFBXENQQ4J", "fCnt": 5, "time": "2026-05-15T11:42:41.291790940+00:00", "fPort": 2, "rxInfo": [{"snr": 5.5, "rssi": -92, "gwTime": "2026-05-15T11:42:40.291299+00:00", "nsTime": "2026-05-15T11:42:40.646428054+00:00", "channel": 7, "context": "amtdYQ==", "location": {"altitude": 51.0, "latitude": 56.171247666666666, "longitude": 10.192123333333333}, "uplinkId": 1705835980, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880579.291790940s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "ec773768-2df1-497a-932c-ba855dd4529c"}
85	2026-05-15 11:43:24.931354+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	7	-90	6.5	6	{"dr": 5, "adr": true, "data": "agcGugSxBd0NrQ51agcG2ASxBd0NrQ51", "fCnt": 6, "time": "2026-05-15T11:43:25.334087995+00:00", "fPort": 2, "rxInfo": [{"snr": 6.5, "rssi": -90, "gwTime": "2026-05-15T11:43:24.334527665+00:00", "nsTime": "2026-05-15T11:43:24.689579749+00:00", "context": "bQtpSQ==", "rfChain": 1, "location": {"altitude": 57.0, "latitude": 56.17132066666667, "longitude": 10.192101333333333}, "uplinkId": 123215276, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880623.334087995s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "be4c8d31-1caf-43b4-a084-9238511ee409"}
86	2026-05-15 11:44:08.917395+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	7	-92	7	7	{"dr": 5, "adr": true, "data": "agcG9gVSBn4OTg8W", "fCnt": 7, "time": "2026-05-15T11:44:09.337609735+00:00", "fPort": 2, "rxInfo": [{"snr": 7.0, "rssi": -92, "gwTime": "2026-05-15T11:44:08.337981+00:00", "nsTime": "2026-05-15T11:44:08.697476398+00:00", "channel": 4, "context": "b6rZ0A==", "location": {"altitude": 60.0, "latitude": 56.171338666666664, "longitude": 10.192101}, "uplinkId": 3444670069, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880667.337609735s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "ad210d61-3775-4725-9623-ce3900f95815"}
87	2026-05-15 11:44:52.982918+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	7	-93	6.75	8	{"dr": 5, "adr": true, "data": "agcHFAVSBn4OTg8WagcHMwW+BuoOug+C", "fCnt": 8, "time": "2026-05-15T11:44:53.387929186+00:00", "fPort": 2, "rxInfo": [{"snr": 6.75, "rssi": -93, "gwTime": "2026-05-15T11:44:52.388232+00:00", "nsTime": "2026-05-15T11:44:52.742222443+00:00", "channel": 6, "context": "cksBJQ==", "location": {"altitude": 60.0, "latitude": 56.17133616666667, "longitude": 10.1921185}, "uplinkId": 847913792, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880711.387929186s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "0e8db3fa-7550-4606-9bb9-01fb87baff07"}
88	2026-05-15 11:45:36.972617+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868500000	125000	7	-91	5.25	9	{"dr": 5, "adr": true, "data": "agcHUQYqB1YPJg/u", "fCnt": 9, "time": "2026-05-15T11:45:37.389956673+00:00", "fPort": 2, "rxInfo": [{"snr": 5.25, "rssi": -91, "gwTime": "2026-05-15T11:45:36.390191+00:00", "nsTime": "2026-05-15T11:45:36.746767681+00:00", "channel": 2, "context": "dOpr1g==", "rfChain": 1, "location": {"altitude": 54.0, "latitude": 56.171246833333335, "longitude": 10.192141}, "uplinkId": 1132328106, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880755.389956673s"}], "txInfo": {"frequency": 868500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "90a96ad5-b2ef-46f2-9bbc-cb4bde5882ba"}
89	2026-05-15 11:46:21.006734+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	7	-93	5	10	{"dr": 5, "adr": true, "data": "agcHbwYqB1YPJg/uagcHjQZfB4sPWxAj", "fCnt": 10, "time": "2026-05-15T11:46:21.437295135+00:00", "fPort": 2, "rxInfo": [{"snr": 5.0, "rssi": -93, "gwTime": "2026-05-15T11:46:20.437461+00:00", "nsTime": "2026-05-15T11:46:20.786860721+00:00", "channel": 3, "context": "d4qHhw==", "location": {"altitude": 57.0, "latitude": 56.171256, "longitude": 10.192086333333334}, "uplinkId": 1274052730, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880799.437295135s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "bd24437a-f6b4-408a-9127-054227fc1531"}
90	2026-05-15 11:47:05.037234+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	7	-97	4.5	11	{"dr": 5, "adr": true, "data": "agcHqwaVB8EPkRBZ", "fCnt": 11, "time": "2026-05-15T11:47:05.438304678+00:00", "fPort": 2, "rxInfo": [{"snr": 4.5, "rssi": -97, "gwTime": "2026-05-15T11:47:04.438402+00:00", "nsTime": "2026-05-15T11:47:04.800786717+00:00", "context": "einuPg==", "rfChain": 1, "location": {"altitude": 65.0, "latitude": 56.17129633333333, "longitude": 10.192033833333333}, "uplinkId": 3257480911, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880843.438304678s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "aec0d9a2-386e-4a1a-906b-7a54232e3880"}
91	2026-05-15 11:47:49.058752+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868500000	125000	7	-99	0.75	12	{"dr": 5, "adr": true, "data": "agcHyQaVB8EPkRBZ", "fCnt": 12, "time": "2026-05-15T11:47:49.464604371+00:00", "fPort": 2, "rxInfo": [{"snr": 0.75, "rssi": -99, "gwTime": "2026-05-15T11:47:48.464633+00:00", "nsTime": "2026-05-15T11:47:48.819554381+00:00", "channel": 2, "context": "fMm3wA==", "rfChain": 1, "location": {"altitude": 99.0, "latitude": 56.17149383333334, "longitude": 10.191930666666666}, "uplinkId": 604703872, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880887.464604371s"}], "txInfo": {"frequency": 868500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "9f175ea9-5ea5-4906-84f4-cf312de6a08f"}
92	2026-05-15 11:48:33.082158+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	7	-99	1	13	{"dr": 5, "adr": true, "data": "agcH5wcBCC0P/RDFagcIBQc3CGMQMxD7", "fCnt": 13, "time": "2026-05-15T11:48:33.509436385+00:00", "fPort": 2, "rxInfo": [{"snr": 1.0, "rssi": -99, "gwTime": "2026-05-15T11:48:32.509395999+00:00", "nsTime": "2026-05-15T11:48:32.866291740+00:00", "channel": 6, "context": "f2nJpg==", "location": {"altitude": 109.0, "latitude": 56.171528333333335, "longitude": 10.191928}, "uplinkId": 726782923, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880931.509436385s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "23fe1631-5777-43c4-a5c2-1a1d350bd5fd"}
93	2026-05-15 11:49:17.09982+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	7	-97	3	14	{"dr": 5, "adr": true, "data": "agcIIwdsCJgQaBEw", "fCnt": 14, "time": "2026-05-15T11:49:17.511442258+00:00", "fPort": 2, "rxInfo": [{"snr": 3.0, "rssi": -97, "gwTime": "2026-05-15T11:49:16.511333+00:00", "nsTime": "2026-05-15T11:49:16.864753440+00:00", "context": "ggk0Qg==", "rfChain": 1, "location": {"altitude": 90.0, "latitude": 56.17159216666667, "longitude": 10.191868}, "uplinkId": 627624047, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462880975.511442258s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "49e81060-4ba4-47cc-999a-286a4c156886"}
94	2026-05-15 11:50:01.148047+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	7	-97	1.5	15	{"dr": 5, "adr": true, "data": "agcIQQdsCJgQaBEwagcIXweiCM4QnhFm", "fCnt": 15, "time": "2026-05-15T11:50:01.558966891+00:00", "fPort": 2, "rxInfo": [{"snr": 1.5, "rssi": -97, "gwTime": "2026-05-15T11:50:00.558789+00:00", "nsTime": "2026-05-15T11:50:00.909642414+00:00", "channel": 4, "context": "hKlQrA==", "location": {"altitude": 79.0, "latitude": 56.171494, "longitude": 10.1919705}, "uplinkId": 2697807379, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881019.558966891s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "e7e45614-f3cc-4866-b011-7dcdd10183d8"}
95	2026-05-15 11:51:29.210652+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	7	-95	2	17	{"dr": 5, "adr": true, "data": "agcImwfYCQQQ1BGcagcIuQfYCQQQ1BGc", "fCnt": 17, "time": "2026-05-15T11:51:29.608979677+00:00", "fPort": 2, "rxInfo": [{"snr": 2.0, "rssi": -95, "gwTime": "2026-05-15T11:51:28.608665+00:00", "nsTime": "2026-05-15T11:51:28.963381409+00:00", "channel": 3, "context": "iejZkw==", "location": {"altitude": 106.0, "latitude": 56.17141616666667, "longitude": 10.191900833333333}, "uplinkId": 4015582481, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881107.608979677s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "b7988c03-a3c7-49d6-9572-d5c89e19038e"}
96	2026-05-15 11:51:30.49781+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	7	-95	2.25	18	{"dr": 5, "adr": true, "data": "agcBVQH1AyIK8gu6agcGBAH1AyIK8gu6", "fCnt": 18, "time": "2026-05-15T11:51:30.924621231+00:00", "fPort": 2, "rxInfo": [{"snr": 2.25, "rssi": -95, "gwTime": "2026-05-15T11:51:29.924305+00:00", "nsTime": "2026-05-15T11:51:30.274813267+00:00", "channel": 3, "context": "ifzsyw==", "location": {"altitude": 106.0, "latitude": 56.17141616666667, "longitude": 10.191900833333333}, "uplinkId": 2204436252, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881108.924621231s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "87a5e911-de64-4c40-8539-9235c976ee91"}
97	2026-05-15 11:52:12.494596+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	7	-93	4.25	19	{"dr": 5, "adr": true, "data": "agcI1whDCW8RQBII", "fCnt": 19, "time": "2026-05-15T11:52:12.909348509+00:00", "fPort": 2, "rxInfo": [{"snr": 4.25, "rssi": -93, "gwTime": "2026-05-15T11:52:11.908967+00:00", "nsTime": "2026-05-15T11:52:12.261266066+00:00", "channel": 1, "context": "jH2Pag==", "rfChain": 1, "location": {"altitude": 120.0, "latitude": 56.17150866666667, "longitude": 10.191831166666667}, "uplinkId": 4219861507, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881150.909348509s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "01df6878-217c-4c16-b33c-a0337672e8a6"}
98	2026-05-15 11:52:56.563171+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868500000	125000	7	-93	4.5	20	{"dr": 5, "adr": true, "data": "agcI9QhDCW8RQBIIagcJEwhDCW8RQBII", "fCnt": 20, "time": "2026-05-15T11:52:56.963744990+00:00", "fPort": 2, "rxInfo": [{"snr": 4.5, "rssi": -93, "gwTime": "2026-05-15T11:52:55.963295036+00:00", "nsTime": "2026-05-15T11:52:56.312175471+00:00", "channel": 2, "context": "jx3GrQ==", "rfChain": 1, "location": {"altitude": 81.0, "latitude": 56.17133666666667, "longitude": 10.192006166666667}, "uplinkId": 1845776416, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881194.963744990s"}], "txInfo": {"frequency": 868500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "e1f7133b-889c-465c-8802-3afaa5c997a5"}
99	2026-05-15 11:53:40.556789+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	7	-96	3.5	21	{"dr": 5, "adr": true, "data": "agcJMQivCdsRqxJz", "fCnt": 21, "time": "2026-05-15T11:53:40.963156282+00:00", "fPort": 2, "rxInfo": [{"snr": 3.5, "rssi": -96, "gwTime": "2026-05-15T11:53:39.963638+00:00", "nsTime": "2026-05-15T11:53:40.314321053+00:00", "channel": 7, "context": "kb0rDA==", "location": {"altitude": 76.0, "latitude": 56.17134183333334, "longitude": 10.192043833333333}, "uplinkId": 3182369367, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881238.963156282s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "32b70733-9c42-4471-b8c2-540bcc73ae7c"}
100	2026-05-15 11:54:24.601168+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	7	-97	3.25	22	{"dr": 5, "adr": true, "data": "agcJTwhDCW8RQBIIagcJbQivCdsRqxJz", "fCnt": 22, "time": "2026-05-15T11:54:25.011220648+00:00", "fPort": 2, "rxInfo": [{"snr": 3.25, "rssi": -97, "gwTime": "2026-05-15T11:54:24.011633999+00:00", "nsTime": "2026-05-15T11:54:24.365426149+00:00", "context": "lF1JkQ==", "rfChain": 1, "location": {"altitude": 91.0, "latitude": 56.171408, "longitude": 10.192000833333333}, "uplinkId": 2136518806, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881283.011220648s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "dc8eb3a8-6af5-4c51-9056-86b46663f117"}
101	2026-05-15 11:55:08.580342+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	7	-97	\N	23	{"dr": 5, "adr": true, "data": "agcJiwkbCkcSFxLf", "fCnt": 23, "time": "2026-05-15T11:55:09.012222087+00:00", "fPort": 2, "rxInfo": [{"rssi": -97, "gwTime": "2026-05-15T11:55:08.012566999+00:00", "nsTime": "2026-05-15T11:55:08.359116467+00:00", "channel": 5, "context": "lvywQA==", "location": {"altitude": 76.0, "latitude": 56.171314, "longitude": 10.192066333333333}, "uplinkId": 1998781049, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881327.012222087s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "2e1291f5-3987-4c45-8cd7-257042bd3c65"}
102	2026-05-15 11:55:52.652355+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	7	-97	1.5	24	{"dr": 5, "adr": true, "data": "agcJqQjlChER4RKpagcJxwjlChER4RKp", "fCnt": 24, "time": "2026-05-15T11:55:53.059110626+00:00", "fPort": 2, "rxInfo": [{"snr": 1.5, "rssi": -97, "gwTime": "2026-05-15T11:55:52.059387+00:00", "nsTime": "2026-05-15T11:55:52.407449186+00:00", "channel": 6, "context": "mZzKLg==", "location": {"altitude": 86.0, "latitude": 56.1713535, "longitude": 10.192075333333333}, "uplinkId": 850143206, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881371.059110626s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "a5072368-d2b2-47f4-aad3-49ed43ffe506"}
103	2026-05-15 11:56:36.645983+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	7	-98	0.75	25	{"dr": 5, "adr": true, "data": "agcJ5QkbCkcSFxLf", "fCnt": 25, "time": "2026-05-15T11:56:37.060246443+00:00", "fPort": 2, "rxInfo": [{"snr": 0.75, "rssi": -98, "gwTime": "2026-05-15T11:56:36.060454+00:00", "nsTime": "2026-05-15T11:56:36.406263080+00:00", "channel": 3, "context": "nDwxYw==", "location": {"altitude": 74.0, "latitude": 56.171331333333335, "longitude": 10.192063833333334}, "uplinkId": 3036123381, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881415.060246443s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "940740b1-fac1-4312-991a-dd96e9d96dac"}
104	2026-05-15 11:57:20.685889+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	7	-95	3.75	26	{"dr": 5, "adr": true, "data": "agcKAwkbCkcSFxLf", "fCnt": 26, "time": "2026-05-15T11:57:21.084092961+00:00", "fPort": 2, "rxInfo": [{"snr": 3.75, "rssi": -95, "gwTime": "2026-05-15T11:57:20.084230+00:00", "nsTime": "2026-05-15T11:57:20.437529131+00:00", "channel": 4, "context": "ntvxTg==", "location": {"altitude": 97.0, "latitude": 56.17148533333334, "longitude": 10.192069833333333}, "uplinkId": 1727091257, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881459.084092961s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "9f096a1d-c840-48ec-b84b-632a08c2674f"}
105	2026-05-15 11:58:04.732677+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	7	-97	2.75	27	{"dr": 5, "adr": true, "data": "agcKIQkbCkcSFxLfagcKPwjlChER4RKp", "fCnt": 27, "time": "2026-05-15T11:58:10.131173169+00:00", "fPort": 2, "rxInfo": [{"snr": 2.75, "rssi": -97, "gwTime": "2026-05-15T11:58:09.131241+00:00", "nsTime": "2026-05-15T11:58:04.478956192+00:00", "channel": 1, "context": "oXwL+w==", "rfChain": 1, "location": {"altitude": 128.0, "latitude": 56.171670166666665, "longitude": 10.191963833333332}, "uplinkId": 1367582543, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881508.131173169s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "1ef7abbf-a7b3-4083-a774-3447b4589520"}
106	2026-05-15 11:58:48.705094+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868300000	125000	7	-98	1.5	28	{"dr": 5, "adr": true, "data": "agcKXQkbCkcSFxLf", "fCnt": 28, "time": "2026-05-15T11:58:49.131910293+00:00", "fPort": 2, "rxInfo": [{"snr": 1.5, "rssi": -98, "gwTime": "2026-05-15T11:58:48.131909+00:00", "nsTime": "2026-05-15T11:58:48.480217507+00:00", "channel": 1, "context": "pBtxow==", "rfChain": 1, "location": {"altitude": 114.0, "latitude": 56.171643, "longitude": 10.192057833333333}, "uplinkId": 2900572406, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881547.131910293s"}], "txInfo": {"frequency": 868300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "0eb2e260-df38-4d48-afc2-2f81e357dc26"}
107	2026-05-15 11:59:32.765611+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	7	-96	2	29	{"dr": 5, "adr": true, "data": "agcKfAkbCkcSFxLfagcKmglRCn0STRMV", "fCnt": 29, "time": "2026-05-15T11:59:33.179373053+00:00", "fPort": 2, "rxInfo": [{"snr": 2.0, "rssi": -96, "gwTime": "2026-05-15T11:59:32.179302820+00:00", "nsTime": "2026-05-15T11:59:32.527513104+00:00", "channel": 6, "context": "pruN0A==", "location": {"altitude": 124.0, "latitude": 56.17168266666667, "longitude": 10.192018166666667}, "uplinkId": 938403433, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881591.179373053s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "d3574121-d4ab-48f6-8f58-332aa2743df5"}
108	2026-05-15 12:00:16.761219+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867900000	125000	7	-96	2.25	30	{"dr": 5, "adr": true, "data": "agcKuAmGCrISghNK", "fCnt": 30, "time": "2026-05-15T12:00:17.179570417+00:00", "fPort": 2, "rxInfo": [{"snr": 2.25, "rssi": -96, "gwTime": "2026-05-15T12:00:16.179431+00:00", "nsTime": "2026-05-15T12:00:16.527825065+00:00", "channel": 7, "context": "qVrxWg==", "location": {"altitude": 142.0, "latitude": 56.1717935, "longitude": 10.191997333333333}, "uplinkId": 3094952984, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881635.179570417s"}], "txInfo": {"frequency": 867900000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "4f560482-797e-4750-9d00-2446730d985c"}
109	2026-05-15 12:01:00.82968+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867300000	125000	7	-94	4.25	31	{"dr": 5, "adr": true, "data": "agcK1gmGCrISghNKagcK9AmGCrISghNK", "fCnt": 31, "time": "2026-05-15T12:01:01.226770832+00:00", "fPort": 2, "rxInfo": [{"snr": 4.25, "rssi": -94, "gwTime": "2026-05-15T12:01:00.226561773+00:00", "nsTime": "2026-05-15T12:01:00.580047108+00:00", "channel": 4, "context": "q/sMgQ==", "location": {"altitude": 163.0, "latitude": 56.17181333333333, "longitude": 10.1918185}, "uplinkId": 1314271588, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881679.226770832s"}], "txInfo": {"frequency": 867300000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "1e9e624a-0483-456c-b67e-95f9a63924e7"}
110	2026-05-15 12:01:44.819998+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	7	-96	2.5	32	{"dr": 5, "adr": true, "data": "agcLEgmGCrISghNK", "fCnt": 32, "time": "2026-05-15T12:01:45.227296889+00:00", "fPort": 2, "rxInfo": [{"snr": 2.5, "rssi": -96, "gwTime": "2026-05-15T12:01:44.227018+00:00", "nsTime": "2026-05-15T12:01:44.575515272+00:00", "channel": 6, "context": "rppxVA==", "location": {"altitude": 167.0, "latitude": 56.171775333333336, "longitude": 10.191774333333333}, "uplinkId": 1665292416, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881723.227296889s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "47b17f16-e4ef-4dd7-b518-93032908f154"}
111	2026-05-15 12:02:28.856425+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	7	-96	3.25	33	{"dr": 5, "adr": true, "data": "agcLMAmGCrISghNKagcLTgnyCx4S7hO2", "fCnt": 33, "time": "2026-05-15T12:02:29.276081425+00:00", "fPort": 2, "rxInfo": [{"snr": 3.25, "rssi": -96, "gwTime": "2026-05-15T12:02:28.275733+00:00", "nsTime": "2026-05-15T12:02:28.622661562+00:00", "channel": 3, "context": "sTqSqg==", "location": {"altitude": 172.0, "latitude": 56.17176116666667, "longitude": 10.191771833333334}, "uplinkId": 1028853658, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881767.276081425s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "5089413a-0aba-47ba-82ec-67aaa4f63b87"}
112	2026-05-15 12:02:30.22964+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	7	-97	3	34	{"dr": 5, "adr": true, "data": "agcBVQH1AyIK8gu6agcGBAH1AyIK8gu6agcGIwIrA1cLJwvvagcGQQLNA/kLyQyR", "fCnt": 34, "time": "2026-05-15T12:02:30.627349003+00:00", "fPort": 2, "rxInfo": [{"snr": 3.0, "rssi": -97, "gwTime": "2026-05-15T12:02:29.626999+00:00", "nsTime": "2026-05-15T12:02:29.981220336+00:00", "channel": 3, "context": "sU8xDA==", "location": {"altitude": 172.0, "latitude": 56.17176116666667, "longitude": 10.191771833333334}, "uplinkId": 1492913182, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881768.627349003s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "baf3f8c6-e337-4eda-b559-ea623599b01e"}
113	2026-05-15 12:02:50.23651+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868500000	125000	7	-95	2.25	36	{"dr": 5, "adr": true, "data": "agcG2ASxBd0NrQ51agcG9gVSBn4OTg8WagcHFAVSBn4OTg8WagcHMwW+BuoOug+C", "fCnt": 36, "time": "2026-05-15T12:02:50.636352599+00:00", "fPort": 2, "rxInfo": [{"snr": 2.25, "rssi": -95, "gwTime": "2026-05-15T12:02:49.635971+00:00", "nsTime": "2026-05-15T12:02:49.989843547+00:00", "channel": 2, "context": "soCBHQ==", "rfChain": 1, "location": {"altitude": 175.0, "latitude": 56.1717645, "longitude": 10.191713833333333}, "uplinkId": 578521447, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881788.636352599s"}], "txInfo": {"frequency": 868500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "4010e7e6-7727-43f6-9303-374b09608708"}
114	2026-05-15 12:03:00.213269+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	7	-96	2.5	37	{"dr": 5, "adr": true, "data": "agcLbAm8CugSuBOAagcHUQYqB1YPJg/uagcHbwYqB1YPJg/uagcHjQZfB4sPWxAj", "fCnt": 37, "time": "2026-05-15T12:03:00.646203775+00:00", "fPort": 2, "rxInfo": [{"snr": 2.5, "rssi": -96, "gwTime": "2026-05-15T12:02:59.645806354+00:00", "nsTime": "2026-05-15T12:02:59.996430140+00:00", "channel": 6, "context": "sxk+DA==", "location": {"altitude": 175.0, "latitude": 56.1717645, "longitude": 10.191713833333333}, "uplinkId": 1004854018, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881798.646203775s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "b9175134-45a4-4001-9971-ce40ec94dbc7"}
115	2026-05-15 12:03:20.235905+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	7	-97	1	39	{"dr": 5, "adr": true, "data": "agcIIwdsCJgQaBEwagcIQQdsCJgQaBEwagcIXweiCM4QnhFmagcIfQfYCQQQ1BGc", "fCnt": 39, "time": "2026-05-15T12:03:20.650525310+00:00", "fPort": 2, "rxInfo": [{"snr": 1.0, "rssi": -97, "gwTime": "2026-05-15T12:03:19.650096349+00:00", "nsTime": "2026-05-15T12:03:19.995838267+00:00", "channel": 5, "context": "tEp70w==", "location": {"altitude": 171.0, "latitude": 56.171741, "longitude": 10.191788}, "uplinkId": 418855228, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881818.650525310s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "da736497-46ed-4d19-8148-ad89d1cccac8"}
116	2026-05-15 12:03:30.211502+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867500000	125000	7	-97	1.25	40	{"dr": 5, "adr": true, "data": "agcLignyCx4S7hO2agcImwfYCQQQ1BGc", "fCnt": 40, "time": "2026-05-15T12:03:30.619352724+00:00", "fPort": 2, "rxInfo": [{"snr": 1.25, "rssi": -97, "gwTime": "2026-05-15T12:03:29.618908+00:00", "nsTime": "2026-05-15T12:03:29.965514508+00:00", "channel": 5, "context": "tOKYgA==", "location": {"altitude": 171.0, "latitude": 56.171741, "longitude": 10.191788}, "uplinkId": 2125940786, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881828.619352724s"}], "txInfo": {"frequency": 867500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "9e9416de-ade3-4ff7-ad0e-01c137dec441"}
117	2026-05-15 12:04:12.185887+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	7	-99	2	41	{"dr": 5, "adr": true, "data": "agcLqAnyCx4S7hO2", "fCnt": 41, "time": "2026-05-15T12:04:12.600831917+00:00", "fPort": 2, "rxInfo": [{"snr": 2.0, "rssi": -99, "gwTime": "2026-05-15T12:04:11.601321+00:00", "nsTime": "2026-05-15T12:04:11.949250707+00:00", "channel": 3, "context": "t2MyVw==", "location": {"altitude": 173.0, "latitude": 56.171768, "longitude": 10.191834333333333}, "uplinkId": 2675310180, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881870.600831917s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "16f39433-6068-4583-bf8d-ba78acd48b66"}
118	2026-05-15 12:04:56.225474+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867100000	125000	7	-97	1.5	42	{"dr": 5, "adr": true, "data": "agcLxgnyCx4S7hO2agcL5AnyCx4S7hO2", "fCnt": 42, "time": "2026-05-15T12:04:56.649158813+00:00", "fPort": 2, "rxInfo": [{"snr": 1.5, "rssi": -97, "gwTime": "2026-05-15T12:04:55.649578350+00:00", "nsTime": "2026-05-15T12:04:55.994644199+00:00", "channel": 3, "context": "ugNR5A==", "location": {"altitude": 182.0, "latitude": 56.171688, "longitude": 10.191936166666666}, "uplinkId": 2130459246, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881914.649158813s"}], "txInfo": {"frequency": 867100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "c2d647f9-cd92-4326-8c19-0e86abccbdbb"}
119	2026-05-15 12:05:40.23812+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868100000	125000	7	-95	3.75	43	{"dr": 5, "adr": true, "data": "agcMAgooC1QTJBPs", "fCnt": 43, "time": "2026-05-15T12:05:40.651558603+00:00", "fPort": 2, "rxInfo": [{"snr": 3.75, "rssi": -95, "gwTime": "2026-05-15T12:05:39.651908348+00:00", "nsTime": "2026-05-15T12:05:39.998099775+00:00", "context": "vKK+CQ==", "rfChain": 1, "location": {"altitude": 145.0, "latitude": 56.171716, "longitude": 10.191892166666667}, "uplinkId": 4013968738, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462881958.651558603s"}], "txInfo": {"frequency": 868100000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "e7caef9e-f754-4565-804e-5a78425694a8"}
120	2026-05-15 12:06:24.279693+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	868500000	125000	7	-92	4.25	44	{"dr": 5, "adr": true, "data": "agcMIApeC4oTWhQiagcMPgpeC4oTWhQi", "fCnt": 44, "time": "2026-05-15T12:06:24.698599181+00:00", "fPort": 2, "rxInfo": [{"snr": 4.25, "rssi": -92, "gwTime": "2026-05-15T12:06:23.698879+00:00", "nsTime": "2026-05-15T12:06:24.044103821+00:00", "channel": 2, "context": "v0LYjg==", "rfChain": 1, "location": {"altitude": 117.0, "latitude": 56.17166133333333, "longitude": 10.192110833333333}, "uplinkId": 503809598, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462882002.698599181s"}], "txInfo": {"frequency": 868500000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "e78983f0-7c9c-4a18-9048-a6db00cc1c01"}
121	2026-05-15 12:07:08.288766+00	ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	0016c001f1237a90	867700000	125000	7	-94	3.5	45	{"dr": 5, "adr": true, "data": "agcMXApeC4oTWhQi", "fCnt": 45, "time": "2026-05-15T12:07:08.701663171+00:00", "fPort": 2, "rxInfo": [{"snr": 3.5, "rssi": -94, "gwTime": "2026-05-15T12:07:07.701873+00:00", "nsTime": "2026-05-15T12:07:08.049427824+00:00", "channel": 6, "context": "weJHSw==", "location": {"altitude": 114.0, "latitude": 56.17160966666667, "longitude": 10.192000833333333}, "uplinkId": 2656729045, "crcStatus": "CRC_OK", "gatewayId": "0016c001f1237a90", "timeSinceGpsEpoch": "1462882046.701663171s"}], "txInfo": {"frequency": 867700000, "modulation": {"lora": {"codeRate": "CR_4_5", "bandwidth": 125000, "spreadingFactor": 7}}}, "devAddr": "017206b1", "confirmed": false, "deviceInfo": {"tags": {}, "devEui": "ac1f09fffe1acbd5", "tenantId": "6907c16e-d659-4169-a8a4-74ca3de13f71", "deviceName": "EndDevice1", "tenantName": "ChirpStack", "applicationId": "f2839f47-fb92-449c-989b-0fe83f3d5ea7", "applicationName": "IoT Powerline Monitoring Sstem", "deviceProfileId": "73505660-5481-4717-8e44-a532c5ae1d1f", "deviceProfileName": "EndDevice", "deviceClassEnabled": "CLASS_A"}, "regionConfigId": "eu868", "deduplicationId": "af78a225-8e9e-4c34-abbb-8a93bba63e0e"}
\.


--
-- Data for Name: pending_recovery; Type: TABLE DATA; Schema: public; Owner: app_user
--

COPY public.pending_recovery (device_eui, app_id, start_ts, end_ts, last_requested_at, retry_count, created_at, updated_at) FROM stdin;
ac1f09fffe1acbd5	f2839f47-fb92-449c-989b-0fe83f3d5ea7	1778843982	1778845880	1778846523.232622	1	2026-05-15 11:40:31.012741+00	2026-05-15 12:02:03.304143+00
\.


--
-- Data for Name: sensor_data; Type: TABLE DATA; Schema: public; Owner: app_user
--

COPY public.sensor_data (id, device_timestamp, server_timestamp, device_eui, ambient_temp, immediate_temp, conductor_temp, cpu_temp, raw_payload) FROM stdin;
1	2026-05-07 11:55:11+00	2026-05-07 11:55:48.82356+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7d9f09f20b1e12ee13b6
2	2026-05-07 11:55:41+00	2026-05-07 11:55:48.833623+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7dbd09f20b1e12ee13b6
3	2026-05-07 11:56:11+00	2026-05-07 11:56:32.911538+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7ddb09f20b1e12ee13b6
4	2026-05-07 11:56:41+00	2026-05-07 11:57:16.848253+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7df909f20b1e12ee13b6
5	2026-05-07 11:57:11+00	2026-05-07 11:57:16.855267+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc7e170a280b54132413ec
6	2026-05-07 11:57:41+00	2026-05-07 11:58:00.911449+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7e3509f20b1e12ee13b6
7	2026-05-07 11:58:11+00	2026-05-07 11:58:44.987142+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7e5309f20b1e12ee13b6
8	2026-05-07 11:58:41+00	2026-05-07 11:58:45.003139+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7e7109f20b1e12ee13b6
9	2026-05-07 11:59:11+00	2026-05-07 11:59:28.885148+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7e8f09f20b1e12ee13b6
10	2026-05-07 11:59:41+00	2026-05-07 12:00:12.921231+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7ead09f20b1e12ee13b6
11	2026-05-07 12:00:11+00	2026-05-07 12:00:12.928797+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7ecb09f20b1e12ee13b6
12	2026-05-07 12:00:41+00	2026-05-07 12:00:57.033796+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7ee909f20b1e12ee13b6
13	2026-05-07 12:01:11+00	2026-05-07 12:01:41.131488+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7f0709f20b1e12ee13b6
14	2026-05-07 12:01:41+00	2026-05-07 12:02:25.155958+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc7f250a280b54132413ec
15	2026-05-07 12:02:12+00	2026-05-07 12:02:25.17248+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7f4409f20b1e12ee13b6
16	2026-05-07 12:07:12+00	2026-05-07 12:07:33.300528+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc80700a280b54132413ec
17	2026-05-07 12:07:42+00	2026-05-07 12:08:17.339732+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc808e09f20b1e12ee13b6
18	2026-05-07 12:08:12+00	2026-05-07 12:08:17.347682+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc80ac09f20b1e12ee13b6
19	2026-05-07 12:02:42+00	2026-05-07 12:08:18.608946+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc7f620a5e0b8a135a1422
20	2026-05-07 12:03:12+00	2026-05-07 12:08:18.623101+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc7f800a280b54132413ec
21	2026-05-07 12:03:42+00	2026-05-07 12:08:18.627989+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7f9e09f20b1e12ee13b6
22	2026-05-07 12:04:12+00	2026-05-07 12:08:18.634423+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7fbc09f20b1e12ee13b6
23	2026-05-07 12:04:42+00	2026-05-07 12:08:28.648434+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7fda09f20b1e12ee13b6
24	2026-05-07 12:05:12+00	2026-05-07 12:08:28.655765+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc7ff809f20b1e12ee13b6
25	2026-05-07 12:05:42+00	2026-05-07 12:08:28.658286+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc80160a5e0b8a135a1422
26	2026-05-07 12:06:12+00	2026-05-07 12:08:28.660156+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc803409f20b1e12ee13b6
27	2026-05-07 12:06:42+00	2026-05-07 12:08:38.546617+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc805209f20b1e12ee13b6
28	2026-05-07 12:08:42+00	2026-05-07 12:09:20.577347+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc80ca0a280b54132413ec
29	2026-05-07 12:09:12+00	2026-05-07 12:09:20.584354+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc80e809f20b1e12ee13b6
30	2026-05-07 12:09:42+00	2026-05-07 12:10:04.686559+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc81060a280b54132413ec
31	2026-05-07 12:10:12+00	2026-05-07 12:10:48.844701+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc812409f20b1e12ee13b6
32	2026-05-07 12:10:43+00	2026-05-07 12:10:48.851742+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc814309f20b1e12ee13b6
33	2026-05-07 12:11:13+00	2026-05-07 12:11:32.679511+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc81610a5e0b8a135a1422
34	2026-05-07 12:11:43+00	2026-05-07 12:12:16.615881+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc817f0a280b54132413ec
35	2026-05-07 12:12:13+00	2026-05-07 12:12:16.624156+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc819d09f20b1e12ee13b6
36	2026-05-07 12:12:43+00	2026-05-07 12:13:00.847981+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc81bb0a280b54132413ec
37	2026-05-07 12:13:13+00	2026-05-07 12:13:44.819693+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc81d90a5e0b8a135a1422
38	2026-05-07 12:13:43+00	2026-05-07 12:13:44.828324+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc81f70a280b54132413ec
39	2026-05-07 12:14:14+00	2026-05-07 12:14:28.83091+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc82160a280b54132413ec
40	2026-05-07 12:14:44+00	2026-05-07 12:15:12.93574+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc82340a280b54132413ec
41	2026-05-07 12:15:14+00	2026-05-07 12:15:56.866137+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc82520a280b54132413ec
42	2026-05-07 12:15:44+00	2026-05-07 12:15:56.880596+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc827009f20b1e12ee13b6
43	2026-05-07 12:16:14+00	2026-05-07 12:16:40.883154+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc828e0a280b54132413ec
44	2026-05-07 12:16:44+00	2026-05-07 12:17:24.984389+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc82ac0a280b54132413ec
45	2026-05-07 12:17:14+00	2026-05-07 12:17:24.991826+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc82ca0a280b54132413ec
46	2026-05-07 12:17:44+00	2026-05-07 12:18:08.951573+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc82e80a5e0b8a135a1422
47	2026-05-07 12:18:14+00	2026-05-07 12:18:53.05225+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc830609f20b1e12ee13b6
48	2026-05-07 12:18:44+00	2026-05-07 12:18:53.061606+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc83240a280b54132413ec
49	2026-05-07 12:19:14+00	2026-05-07 12:19:36.97078+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc834209f20b1e12ee13b6
50	2026-05-07 12:19:44+00	2026-05-07 12:20:20.9963+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc836009f20b1e12ee13b6
51	2026-05-07 12:20:14+00	2026-05-07 12:20:21.005321+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc837e0a280b54132413ec
52	2026-05-07 12:20:44+00	2026-05-07 12:21:05.311183+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc839c0a280b54132413ec
53	2026-05-07 12:21:14+00	2026-05-07 12:21:49.116744+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc83ba09f20b1e12ee13b6
54	2026-05-07 12:21:44+00	2026-05-07 12:21:49.13701+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc83d809f20b1e12ee13b6
55	2026-05-07 12:22:14+00	2026-05-07 12:22:33.464692+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc83f609f20b1e12ee13b6
56	2026-05-07 12:22:44+00	2026-05-07 12:23:17.174534+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc84140a5e0b8a135a1422
57	2026-05-07 12:23:14+00	2026-05-07 12:23:17.187981+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc84320a5e0b8a135a1422
58	2026-05-07 12:23:44+00	2026-05-07 12:24:01.145411+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc845009f20b1e12ee13b6
59	2026-05-07 12:24:15+00	2026-05-07 12:24:45.205024+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc846f0a280b54132413ec
60	2026-05-07 12:24:45+00	2026-05-07 12:25:29.344871+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc848d0a280b54132413ec
61	2026-05-07 12:25:15+00	2026-05-07 12:25:29.353107+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc84ab0a5e0b8a135a1422
62	2026-05-07 12:25:45+00	2026-05-07 12:26:13.166291+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc84c90a280b54132413ec
63	2026-05-07 12:26:15+00	2026-05-07 12:26:57.334483+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc84e70a280b54132413ec
64	2026-05-07 12:26:45+00	2026-05-07 12:26:57.347683+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc85050a5e0b8a135a1422
65	2026-05-07 12:27:15+00	2026-05-07 12:27:41.230945+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc85230a5e0b8a135a1422
66	2026-05-07 12:27:45+00	2026-05-07 12:28:25.260012+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc85410a5e0b8a135a1422
67	2026-05-07 12:28:15+00	2026-05-07 12:28:25.268105+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc855f0a5e0b8a135a1422
68	2026-05-07 12:28:45+00	2026-05-07 12:29:09.313187+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc857d0a280b54132413ec
69	2026-05-07 12:29:15+00	2026-05-07 12:29:53.468324+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc859b0a280b54132413ec
70	2026-05-07 12:29:45+00	2026-05-07 12:29:53.477292+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc85b90a280b54132413ec
71	2026-05-07 12:30:15+00	2026-05-07 12:30:37.364352+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc85d70a280b54132413ec
72	2026-05-07 12:30:45+00	2026-05-07 12:31:21.455978+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc85f50a280b54132413ec
73	2026-05-07 12:31:15+00	2026-05-07 12:31:21.4798+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc86130a280b54132413ec
74	2026-05-07 12:31:45+00	2026-05-07 12:32:05.56841+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc863109f20b1e12ee13b6
75	2026-05-07 12:32:15+00	2026-05-07 12:32:49.40142+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc864f0a280b54132413ec
76	2026-05-07 12:32:45+00	2026-05-07 12:32:49.41118+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc866d0a280b54132413ec
77	2026-05-07 12:33:15+00	2026-05-07 12:33:33.63084+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc868b0a5e0b8a135a1422
78	2026-05-07 12:33:45+00	2026-05-07 12:34:17.724846+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc86a90a280b54132413ec
79	2026-05-07 12:34:15+00	2026-05-07 12:34:17.732639+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc86c70a280b54132413ec
80	2026-05-07 12:34:45+00	2026-05-07 12:35:01.467254+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc86e50a280b54132413ec
81	2026-05-07 12:35:15+00	2026-05-07 12:35:45.50167+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc87030a5e0b8a135a1422
82	2026-05-07 12:35:45+00	2026-05-07 12:36:29.502552+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc872109f20b1e12ee13b6
83	2026-05-07 12:36:15+00	2026-05-07 12:36:29.511249+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc873f0a280b54132413ec
84	2026-05-07 12:36:45+00	2026-05-07 12:37:13.579781+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc875d0a5e0b8a135a1422
85	2026-05-07 12:37:15+00	2026-05-07 12:37:57.566013+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc877b0a280b54132413ec
86	2026-05-07 12:37:46+00	2026-05-07 12:37:57.574204+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc879a0a280b54132413ec
87	2026-05-07 12:38:16+00	2026-05-07 12:38:41.652395+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc87b809f20b1e12ee13b6
88	2026-05-07 12:38:46+00	2026-05-07 12:39:25.612162+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc87d60a280b54132413ec
89	2026-05-07 12:39:16+00	2026-05-07 12:39:25.624095+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc87f40a5e0b8a135a1422
90	2026-05-07 12:39:46+00	2026-05-07 12:40:09.613518+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc88120a280b54132413ec
91	2026-05-07 12:40:16+00	2026-05-07 12:40:53.643012+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc88300a5e0b8a135a1422
92	2026-05-07 12:40:46+00	2026-05-07 12:40:53.650397+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc884e09f20b1e12ee13b6
93	2026-05-07 12:41:16+00	2026-05-07 12:41:37.773662+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc886c0a5e0b8a135a1422
94	2026-05-07 12:41:46+00	2026-05-07 12:42:21.774271+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc888a0a5e0b8a135a1422
95	2026-05-07 12:42:16+00	2026-05-07 12:42:21.789145+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc88a80a280b54132413ec
96	2026-05-07 12:42:46+00	2026-05-07 12:43:05.829746+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc88c60a5e0b8a135a1422
97	2026-05-07 12:43:16+00	2026-05-07 12:43:49.83626+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc88e40a5e0b8a135a1422
98	2026-05-07 12:43:47+00	2026-05-07 12:43:49.843561+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc89030a280b54132413ec
99	2026-05-07 12:44:17+00	2026-05-07 12:44:33.786387+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc89210a5e0b8a135a1422
100	2026-05-07 12:44:47+00	2026-05-07 12:45:17.819582+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc893f09f20b1e12ee13b6
101	2026-05-07 12:45:17+00	2026-05-07 12:46:01.882417+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc895d09f20b1e12ee13b6
102	2026-05-07 12:45:47+00	2026-05-07 12:46:01.898809+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc897b0a5e0b8a135a1422
103	2026-05-07 12:46:17+00	2026-05-07 12:46:46.018161+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc89990a5e0b8a135a1422
104	2026-05-07 12:46:47+00	2026-05-07 12:47:29.990371+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc89b70a5e0b8a135a1422
105	2026-05-07 12:47:17+00	2026-05-07 12:47:30.003625+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc89d50a5e0b8a135a1422
106	2026-05-07 12:47:47+00	2026-05-07 12:48:13.891765+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc89f309f20b1e12ee13b6
107	2026-05-07 12:48:17+00	2026-05-07 12:48:58.204511+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8a110a5e0b8a135a1422
108	2026-05-07 12:48:47+00	2026-05-07 12:48:58.214264+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8a2f0a5e0b8a135a1422
109	2026-05-07 12:49:17+00	2026-05-07 12:49:42.035446+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8a4d0a5e0b8a135a1422
110	2026-05-07 12:49:47+00	2026-05-07 12:50:26.048765+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8a6b0a5e0b8a135a1422
111	2026-05-07 12:50:18+00	2026-05-07 12:50:26.06236+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8a8a0a5e0b8a135a1422
112	2026-05-07 12:50:48+00	2026-05-07 12:51:10.17672+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8aa80a5e0b8a135a1422
113	2026-05-07 12:51:18+00	2026-05-07 12:51:54.059637+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8ac60a5e0b8a135a1422
114	2026-05-07 12:51:48+00	2026-05-07 12:51:54.075522+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8ae40a5e0b8a135a1422
115	2026-05-07 12:52:18+00	2026-05-07 12:52:38.242015+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8b020a5e0b8a135a1422
116	2026-05-07 12:52:48+00	2026-05-07 12:53:22.272887+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8b200a5e0b8a135a1422
117	2026-05-07 12:53:18+00	2026-05-07 12:53:22.283704+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8b3e0a5e0b8a135a1422
118	2026-05-07 12:53:48+00	2026-05-07 12:54:06.079065+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8b5c0a5e0b8a135a1422
119	2026-05-07 12:54:18+00	2026-05-07 12:54:50.231161+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8b7a0a5e0b8a135a1422
120	2026-05-07 12:54:48+00	2026-05-07 12:54:50.246658+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc8b980a280b54132413ec
121	2026-05-07 12:55:18+00	2026-05-07 12:55:34.139938+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc8bb609f20b1e12ee13b6
122	2026-05-07 12:55:48+00	2026-05-07 12:56:18.272225+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8bd40a5e0b8a135a1422
123	2026-05-07 12:56:18+00	2026-05-07 12:57:02.255845+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8bf20a5e0b8a135a1422
124	2026-05-07 12:56:48+00	2026-05-07 12:57:02.263852+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8c100a5e0b8a135a1422
125	2026-05-07 12:57:18+00	2026-05-07 12:57:46.180774+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc8c2e0a280b54132413ec
126	2026-05-07 12:57:48+00	2026-05-07 12:58:30.310249+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8c4c0a5e0b8a135a1422
127	2026-05-07 12:58:18+00	2026-05-07 12:58:30.321666+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc8c6a0a280b54132413ec
128	2026-05-07 12:58:48+00	2026-05-07 12:59:14.236146+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc8c8809f20b1e12ee13b6
129	2026-05-07 12:59:18+00	2026-05-07 12:59:58.301241+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8ca60a5e0b8a135a1422
130	2026-05-07 12:59:48+00	2026-05-07 12:59:58.316205+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8cc40a5e0b8a135a1422
131	2026-05-07 13:00:19+00	2026-05-07 13:00:42.288631+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8ce30a5e0b8a135a1422
132	2026-05-07 13:00:49+00	2026-05-07 13:01:26.330659+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc8d010a930bbf138f1457
133	2026-05-07 13:01:19+00	2026-05-07 13:01:26.34369+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8d1f0a5e0b8a135a1422
134	2026-05-07 13:01:49+00	2026-05-07 13:02:10.3232+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8d3d0a5e0b8a135a1422
135	2026-05-07 13:02:19+00	2026-05-07 13:02:54.385188+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc8d5b09f20b1e12ee13b6
136	2026-05-07 13:02:49+00	2026-05-07 13:02:54.395787+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc8d7909f20b1e12ee13b6
137	2026-05-07 13:03:19+00	2026-05-07 13:03:38.401253+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8d970a5e0b8a135a1422
138	2026-05-07 13:03:49+00	2026-05-07 13:04:22.442605+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc8db509f20b1e12ee13b6
139	2026-05-07 13:04:19+00	2026-05-07 13:04:22.453033+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8dd30a5e0b8a135a1422
140	2026-05-07 13:04:49+00	2026-05-07 13:05:06.395179+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc8df10a930bbf138f1457
141	2026-05-07 13:05:19+00	2026-05-07 13:05:50.475345+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc8e0f0a280b54132413ec
142	2026-05-07 13:05:49+00	2026-05-07 13:05:50.497549+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc8e2d0a280b54132413ec
143	2026-05-07 13:06:19+00	2026-05-07 13:06:34.455918+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc8e4b0a930bbf138f1457
144	2026-05-07 13:06:49+00	2026-05-07 13:07:18.487425+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8e690a5e0b8a135a1422
145	2026-05-07 13:07:19+00	2026-05-07 13:08:02.532649+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8e870a5e0b8a135a1422
146	2026-05-07 13:07:49+00	2026-05-07 13:08:02.545283+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc8ea50a280b54132413ec
147	2026-05-07 13:08:19+00	2026-05-07 13:08:46.562646+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8ec30a5e0b8a135a1422
148	2026-05-07 13:08:49+00	2026-05-07 13:09:30.559895+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8ee10a5e0b8a135a1422
149	2026-05-07 13:09:20+00	2026-05-07 13:09:30.568026+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc8f000a280b54132413ec
150	2026-05-07 13:09:50+00	2026-05-07 13:10:14.605966+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8f1e0a5e0b8a135a1422
151	2026-05-07 13:10:20+00	2026-05-07 13:10:58.658168+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8f3c0a5e0b8a135a1422
152	2026-05-07 13:10:50+00	2026-05-07 13:10:58.668787+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8f5a0a5e0b8a135a1422
153	2026-05-07 13:11:20+00	2026-05-07 13:11:42.598033+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8f780a5e0b8a135a1422
154	2026-05-07 13:11:50+00	2026-05-07 13:12:26.658153+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8f960a5e0b8a135a1422
155	2026-05-07 13:12:20+00	2026-05-07 13:12:26.667972+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8fb40a5e0b8a135a1422
156	2026-05-07 13:12:50+00	2026-05-07 13:13:10.6671+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8fd20a5e0b8a135a1422
157	2026-05-07 13:13:20+00	2026-05-07 13:13:54.70038+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc8ff00a5e0b8a135a1422
158	2026-05-07 13:13:50+00	2026-05-07 13:13:54.707186+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc900e0a5e0b8a135a1422
159	2026-05-07 13:14:20+00	2026-05-07 13:14:38.729545+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc902c0a5e0b8a135a1422
160	2026-05-07 13:14:50+00	2026-05-07 13:15:22.773983+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc904a0a5e0b8a135a1422
161	2026-05-07 13:15:20+00	2026-05-07 13:15:22.789562+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc90680a5e0b8a135a1422
162	2026-05-07 13:15:50+00	2026-05-07 13:16:06.7915+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc90860a5e0b8a135a1422
163	2026-05-07 13:16:20+00	2026-05-07 13:16:50.798637+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc90a40a930bbf138f1457
164	2026-05-07 13:16:50+00	2026-05-07 13:17:34.823426+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc90c20a5e0b8a135a1422
165	2026-05-07 13:17:20+00	2026-05-07 13:17:34.83467+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc90e00a280b54132413ec
166	2026-05-07 13:17:51+00	2026-05-07 13:18:18.853786+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc90ff0a5e0b8a135a1422
167	2026-05-07 13:18:21+00	2026-05-07 13:19:02.9093+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc911d0a280b54132413ec
168	2026-05-07 13:18:51+00	2026-05-07 13:19:02.918265+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc913b0a5e0b8a135a1422
169	2026-05-07 13:19:21+00	2026-05-07 13:19:46.880258+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc91590a5e0b8a135a1422
170	2026-05-07 13:19:51+00	2026-05-07 13:20:30.955488+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc91770a5e0b8a135a1422
171	2026-05-07 13:20:21+00	2026-05-07 13:20:30.963012+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc91950a5e0b8a135a1422
172	2026-05-07 13:20:51+00	2026-05-07 13:21:14.951776+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc91b30a5e0b8a135a1422
173	2026-05-07 13:21:21+00	2026-05-07 13:21:58.975937+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc91d10a280b54132413ec
174	2026-05-07 13:21:51+00	2026-05-07 13:21:58.985156+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc91ef0a280b54132413ec
175	2026-05-07 13:22:21+00	2026-05-07 13:22:42.94357+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc920d0a5e0b8a135a1422
176	2026-05-07 13:22:51+00	2026-05-07 13:23:27.012562+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc922b0a5e0b8a135a1422
177	2026-05-07 13:23:21+00	2026-05-07 13:23:27.028555+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc92490a5e0b8a135a1422
178	2026-05-07 13:23:51+00	2026-05-07 13:24:11.012682+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc92670a5e0b8a135a1422
179	2026-05-07 13:24:21+00	2026-05-07 13:24:55.087435+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc92850a280b54132413ec
180	2026-05-07 13:24:51+00	2026-05-07 13:24:55.106629+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc92a30a5e0b8a135a1422
181	2026-05-07 13:25:21+00	2026-05-07 13:25:39.058961+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc92c109f20b1e12ee13b6
182	2026-05-07 13:25:51+00	2026-05-07 13:26:23.101609+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc92df0a5e0b8a135a1422
183	2026-05-07 13:26:21+00	2026-05-07 13:26:23.108452+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc92fd0a5e0b8a135a1422
184	2026-05-07 13:26:51+00	2026-05-07 13:31:20.003805+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc931b0a5e0b8a135a1422
185	2026-05-07 13:27:21+00	2026-05-07 13:31:20.02061+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc93390a5e0b8a135a1422
186	2026-05-07 13:27:51+00	2026-05-07 13:31:20.024904+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc93570a5e0b8a135a1422
187	2026-05-07 13:28:21+00	2026-05-07 13:31:20.031551+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc93750a5e0b8a135a1422
188	2026-05-07 13:28:51+00	2026-05-07 13:32:01.295786+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc93930a5e0b8a135a1422
189	2026-05-07 13:29:22+00	2026-05-07 13:32:01.30994+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc93b20a5e0b8a135a1422
190	2026-05-07 13:29:52+00	2026-05-07 13:32:01.312449+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc93d00a5e0b8a135a1422
191	2026-05-07 13:30:22+00	2026-05-07 13:32:01.31519+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc93ee0a5e0b8a135a1422
193	2026-05-07 13:30:52+00	2026-05-07 13:32:02.741296+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc940c0a5e0b8a135a1422
194	2026-05-07 13:31:22+00	2026-05-07 13:32:02.743909+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc942a09f20b1e12ee13b6
195	2026-05-07 13:31:52+00	2026-05-07 13:32:02.745927+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc94480a5e0b8a135a1422
198	2026-05-07 13:32:22+00	2026-05-07 13:32:54.655613+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc94660a5e0b8a135a1422
199	2026-05-07 13:32:52+00	2026-05-07 13:32:54.67054+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc94840a5e0b8a135a1422
200	2026-05-07 13:33:22+00	2026-05-07 13:33:38.672737+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc94a20a5e0b8a135a1422
201	2026-05-07 13:33:52+00	2026-05-07 13:34:22.699216+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc94c00a5e0b8a135a1422
202	2026-05-07 13:34:22+00	2026-05-07 13:35:06.740994+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc94de0a5e0b8a135a1422
203	2026-05-07 13:34:53+00	2026-05-07 13:35:06.752298+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc94fd0a5e0b8a135a1422
204	2026-05-07 13:35:23+00	2026-05-07 13:35:50.723349+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc951b0a5e0b8a135a1422
205	2026-05-07 13:35:53+00	2026-05-07 13:36:34.776206+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc95390a5e0b8a135a1422
206	2026-05-07 13:36:23+00	2026-05-07 13:36:34.785502+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc95570a5e0b8a135a1422
207	2026-05-07 13:36:53+00	2026-05-07 13:37:18.793703+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc95750a5e0b8a135a1422
208	2026-05-07 13:37:23+00	2026-05-07 13:38:02.811426+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	69fc95930a280b54132413ec
209	2026-05-07 13:37:53+00	2026-05-07 13:38:02.821354+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc95b10a5e0b8a135a1422
210	2026-05-07 13:38:23+00	2026-05-07 13:38:46.817244+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc95cf0a5e0b8a135a1422
211	2026-05-07 13:38:53+00	2026-05-07 13:39:30.898484+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc95ed0a5e0b8a135a1422
212	2026-05-07 13:39:23+00	2026-05-07 13:39:30.918511+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc960b0a5e0b8a135a1422
213	2026-05-07 13:39:53+00	2026-05-07 13:40:14.848992+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc96290a5e0b8a135a1422
214	2026-05-07 13:40:23+00	2026-05-07 13:40:58.914033+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc96470a5e0b8a135a1422
215	2026-05-07 13:40:53+00	2026-05-07 13:40:58.928434+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc96650a5e0b8a135a1422
216	2026-05-07 13:41:23+00	2026-05-07 13:41:42.923295+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc96830a5e0b8a135a1422
217	2026-05-07 13:41:53+00	2026-05-07 13:42:26.962746+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc96a10a5e0b8a135a1422
218	2026-05-07 13:42:23+00	2026-05-07 13:42:26.976053+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc96bf0a930bbf138f1457
219	2026-05-07 13:42:53+00	2026-05-07 13:43:10.935081+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc96dd0a5e0b8a135a1422
220	2026-05-07 13:43:23+00	2026-05-07 13:43:54.977272+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc96fb0a930bbf138f1457
221	2026-05-07 13:43:53+00	2026-05-07 13:43:54.983276+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc97190a930bbf138f1457
222	2026-05-07 13:44:23+00	2026-05-07 13:44:39.009176+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc97370a5e0b8a135a1422
223	2026-05-07 13:44:53+00	2026-05-07 13:45:23.023683+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc97550a5e0b8a135a1422
224	2026-05-07 13:45:23+00	2026-05-07 13:46:07.103272+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc97730a5e0b8a135a1422
225	2026-05-07 13:45:53+00	2026-05-07 13:46:07.112619+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc97910a5e0b8a135a1422
226	2026-05-07 13:46:24+00	2026-05-07 13:46:51.054644+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc97b00a5e0b8a135a1422
227	2026-05-07 13:46:54+00	2026-05-07 13:47:35.101917+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc97ce0a930bbf138f1457
228	2026-05-07 13:47:24+00	2026-05-07 13:47:35.114886+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc97ec0a5e0b8a135a1422
229	2026-05-07 13:47:54+00	2026-05-07 13:48:19.114459+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc980a0a5e0b8a135a1422
230	2026-05-07 13:48:24+00	2026-05-07 13:49:03.13596+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc98280a5e0b8a135a1422
231	2026-05-07 13:48:54+00	2026-05-07 13:49:03.143072+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc98460a5e0b8a135a1422
232	2026-05-07 13:49:24+00	2026-05-07 13:49:47.138444+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc98640a5e0b8a135a1422
233	2026-05-07 13:49:54+00	2026-05-07 13:50:31.182248+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc98820a5e0b8a135a1422
234	2026-05-07 13:50:24+00	2026-05-07 13:50:31.192284+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc98a00a930bbf138f1457
235	2026-05-07 13:50:54+00	2026-05-07 13:51:15.200963+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc98be0a5e0b8a135a1422
236	2026-05-07 13:51:24+00	2026-05-07 13:51:59.250452+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc98dc0a5e0b8a135a1422
237	2026-05-07 13:51:54+00	2026-05-07 13:51:59.257924+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc98fa0a930bbf138f1457
238	2026-05-07 13:52:24+00	2026-05-07 13:52:43.243619+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc99180a5e0b8a135a1422
239	2026-05-07 13:52:54+00	2026-05-07 13:53:27.289779+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc99360a5e0b8a135a1422
240	2026-05-07 13:53:24+00	2026-05-07 13:53:27.299439+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc99540a5e0b8a135a1422
241	2026-05-07 13:53:54+00	2026-05-07 13:54:11.276508+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc99720a5e0b8a135a1422
242	2026-05-07 13:54:24+00	2026-05-07 13:54:55.359437+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc99900a5e0b8a135a1422
243	2026-05-07 13:54:54+00	2026-05-07 13:54:55.371021+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc99ae0a5e0b8a135a1422
244	2026-05-07 13:55:24+00	2026-05-07 13:55:39.370423+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc99cc0a5e0b8a135a1422
245	2026-05-07 13:55:54+00	2026-05-07 13:56:23.369326+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc99ea0a5e0b8a135a1422
246	2026-05-07 13:56:24+00	2026-05-07 13:57:07.402949+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9a080a5e0b8a135a1422
247	2026-05-07 13:56:54+00	2026-05-07 13:57:07.410394+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9a260a5e0b8a135a1422
248	2026-05-07 13:57:24+00	2026-05-07 13:57:51.405745+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9a440a5e0b8a135a1422
249	2026-05-07 13:57:54+00	2026-05-07 13:58:35.464327+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9a620a5e0b8a135a1422
250	2026-05-07 13:58:24+00	2026-05-07 13:58:35.474369+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9a800a5e0b8a135a1422
251	2026-05-07 13:58:54+00	2026-05-07 13:59:19.454904+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9a9e0a5e0b8a135a1422
252	2026-05-07 13:59:24+00	2026-05-07 14:00:03.47108+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9abc0a5e0b8a135a1422
253	2026-05-07 13:59:55+00	2026-05-07 14:00:03.476903+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc9adb09f20b1e12ee13b6
254	2026-05-07 14:00:25+00	2026-05-07 14:00:47.514962+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9af90a5e0b8a135a1422
255	2026-05-07 14:00:55+00	2026-05-07 14:01:31.559+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9b170a5e0b8a135a1422
256	2026-05-07 14:01:25+00	2026-05-07 14:01:31.571886+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9b350a5e0b8a135a1422
257	2026-05-07 14:01:55+00	2026-05-07 14:02:15.559903+00	ac1f09fffe1acbd5	27.07	30.07	50.07	52.07	69fc9b530a930bbf138f1457
258	2026-05-07 14:02:25+00	2026-05-07 14:02:59.60575+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9b710a5e0b8a135a1422
259	2026-05-07 14:02:55+00	2026-05-07 14:02:59.617058+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	69fc9b8f0a5e0b8a135a1422
260	2026-05-07 14:03:25+00	2026-05-07 14:03:43.307053+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	69fc9bad09f20b1e12ee13b6
261	2026-05-13 07:39:53+00	2026-05-13 07:40:16.006163+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042ac909510a7d124d1315
262	2026-05-13 07:40:23+00	2026-05-13 07:40:58.198994+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a042ae7091b0a47121712df
263	2026-05-13 07:40:53+00	2026-05-13 07:40:58.217498+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a042b05091b0a47121712df
264	2026-05-13 07:39:23+00	2026-05-13 07:40:59.480941+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042aab09860ab21282134a
265	2026-05-13 07:41:23+00	2026-05-13 07:41:41.517884+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042b2309860ab21282134a
266	2026-05-13 07:41:53+00	2026-05-13 07:42:25.824845+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042b4109860ab21282134a
267	2026-05-13 07:42:23+00	2026-05-13 07:42:25.830979+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042b5f09510a7d124d1315
268	2026-05-13 07:42:53+00	2026-05-13 07:43:09.595151+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042b7d09860ab21282134a
269	2026-05-13 07:43:23+00	2026-05-13 07:43:54.049281+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042b9b09860ab21282134a
270	2026-05-13 07:43:53+00	2026-05-13 07:44:37.570403+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a042bb9091b0a47121712df
271	2026-05-13 07:44:23+00	2026-05-13 07:44:37.578519+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042bd709510a7d124d1315
272	2026-05-13 07:44:54+00	2026-05-13 07:45:21.651958+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042bf609510a7d124d1315
273	2026-05-13 07:45:24+00	2026-05-13 07:46:05.660656+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a042c14091b0a47121712df
274	2026-05-13 07:45:54+00	2026-05-13 07:46:05.672026+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a042c32091b0a47121712df
275	2026-05-13 07:46:24+00	2026-05-13 07:46:49.750318+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042c5009510a7d124d1315
276	2026-05-13 07:46:54+00	2026-05-13 07:47:33.764518+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a042c6e091b0a47121712df
277	2026-05-13 07:47:24+00	2026-05-13 07:47:33.781434+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042c8c09510a7d124d1315
278	2026-05-13 07:47:54+00	2026-05-13 07:48:17.746948+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a042caa091b0a47121712df
279	2026-05-13 07:48:24+00	2026-05-13 07:49:01.965971+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042cc809510a7d124d1315
280	2026-05-13 07:48:54+00	2026-05-13 07:49:01.983176+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042ce609860ab21282134a
281	2026-05-13 07:49:24+00	2026-05-13 07:49:45.768023+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042d0409860ab21282134a
282	2026-05-13 07:49:54+00	2026-05-13 07:50:29.796945+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042d2209510a7d124d1315
283	2026-05-13 07:50:24+00	2026-05-13 07:50:29.81132+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042d4009860ab21282134a
284	2026-05-13 07:50:54+00	2026-05-13 07:51:13.84831+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042d5e09860ab21282134a
285	2026-05-13 07:51:24+00	2026-05-13 07:51:57.850612+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042d7c09860ab21282134a
286	2026-05-13 07:51:54+00	2026-05-13 07:51:57.863212+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042d9a09860ab21282134a
287	2026-05-13 07:52:24+00	2026-05-13 07:52:41.877011+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042db809860ab21282134a
288	2026-05-13 07:52:54+00	2026-05-13 07:53:25.941968+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042dd609510a7d124d1315
289	2026-05-13 07:53:24+00	2026-05-13 07:53:25.955034+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042df409860ab21282134a
290	2026-05-13 07:53:54+00	2026-05-13 07:54:09.970728+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042e1209510a7d124d1315
291	2026-05-13 07:54:24+00	2026-05-13 07:54:54.113553+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042e3009860ab21282134a
292	2026-05-13 07:54:54+00	2026-05-13 07:55:38.009194+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042e4e09860ab21282134a
293	2026-05-13 07:55:24+00	2026-05-13 07:55:38.022798+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042e6c09510a7d124d1315
294	2026-05-13 07:55:54+00	2026-05-13 07:56:22.056789+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042e8a09860ab21282134a
295	2026-05-13 07:56:24+00	2026-05-13 07:57:06.0185+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a042ea8091b0a47121712df
296	2026-05-13 07:56:54+00	2026-05-13 07:57:06.025318+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042ec609860ab21282134a
297	2026-05-13 07:57:24+00	2026-05-13 07:57:50.08825+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042ee409860ab21282134a
298	2026-05-13 07:57:54+00	2026-05-13 07:58:34.080232+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042f0209860ab21282134a
299	2026-05-13 07:58:24+00	2026-05-13 07:58:34.088745+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a042f20091b0a47121712df
300	2026-05-13 07:58:54+00	2026-05-13 07:59:18.118666+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a042f3e09bc0ae812b81380
301	2026-05-13 07:59:25+00	2026-05-13 08:00:02.132079+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042f5d09510a7d124d1315
302	2026-05-13 07:59:55+00	2026-05-13 08:00:02.140115+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042f7b09860ab21282134a
303	2026-05-13 08:00:25+00	2026-05-13 08:00:46.193443+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a042f9909510a7d124d1315
304	2026-05-13 08:00:55+00	2026-05-13 08:01:30.273519+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042fb709860ab21282134a
305	2026-05-13 08:01:25+00	2026-05-13 08:01:30.28604+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042fd509860ab21282134a
306	2026-05-13 08:01:55+00	2026-05-13 08:02:14.211727+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a042ff309860ab21282134a
307	2026-05-13 08:02:25+00	2026-05-13 08:02:58.299689+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04301109860ab21282134a
308	2026-05-13 08:02:55+00	2026-05-13 08:02:58.317079+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a04302f09510a7d124d1315
309	2026-05-13 08:03:25+00	2026-05-13 08:03:42.314396+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04304d09860ab21282134a
310	2026-05-13 08:03:55+00	2026-05-13 08:04:26.203997+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04306b09860ab21282134a
311	2026-05-13 08:04:25+00	2026-05-13 08:04:26.21112+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04308909860ab21282134a
312	2026-05-13 08:04:55+00	2026-05-13 08:05:10.208054+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a0430a709510a7d124d1315
313	2026-05-13 08:05:25+00	2026-05-13 08:05:54.234894+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0430c509860ab21282134a
314	2026-05-13 08:05:55+00	2026-05-13 08:06:38.348101+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0430e309860ab21282134a
315	2026-05-13 08:06:25+00	2026-05-13 08:06:38.369382+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04310109860ab21282134a
316	2026-05-13 08:06:55+00	2026-05-13 08:07:22.3193+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04311f09860ab21282134a
317	2026-05-13 08:07:25+00	2026-05-13 08:08:06.344377+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a04313d09510a7d124d1315
318	2026-05-13 08:07:55+00	2026-05-13 08:08:06.352069+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a04315b09510a7d124d1315
319	2026-05-13 08:08:25+00	2026-05-13 08:08:50.438274+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04317909860ab21282134a
320	2026-05-13 08:08:55+00	2026-05-13 08:09:34.399411+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04319709860ab21282134a
321	2026-05-13 08:09:25+00	2026-05-13 08:09:34.407629+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0431b509860ab21282134a
322	2026-05-13 08:09:55+00	2026-05-13 08:10:18.422257+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0431d309860ab21282134a
323	2026-05-13 08:10:25+00	2026-05-13 08:11:02.465132+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a0431f109510a7d124d1315
324	2026-05-13 08:10:55+00	2026-05-13 08:11:02.474696+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a04320f09510a7d124d1315
325	2026-05-13 08:11:25+00	2026-05-13 08:11:46.486933+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04322d09860ab21282134a
326	2026-05-13 08:12:55+00	2026-05-13 08:13:14.74202+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04328709860ab21282134a
327	2026-05-13 08:13:26+00	2026-05-13 08:13:58.86591+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0432a609860ab21282134a
328	2026-05-13 08:13:56+00	2026-05-13 08:13:58.882692+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0432c409860ab21282134a
344	2026-05-13 08:14:26+00	2026-05-13 08:14:29.915443+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0432e209860ab21282134a
356	2026-05-13 08:14:56+00	2026-05-13 08:14:59.945001+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04330009860ab21282134a
368	2026-05-13 08:15:26+00	2026-05-13 08:15:30.110446+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04331e09860ab21282134a
380	2026-05-13 08:15:56+00	2026-05-13 08:16:00.163636+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04333c09860ab21282134a
392	2026-05-13 08:16:26+00	2026-05-13 08:16:30.080638+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04335a09860ab21282134a
399	2026-05-13 08:11:55+00	2026-05-13 08:16:50.073401+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04324b09860ab21282134a
400	2026-05-13 08:12:25+00	2026-05-13 08:16:50.081118+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04326909860ab21282134a
401	2026-05-13 08:16:56+00	2026-05-13 08:17:32.112645+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04337809860ab21282134a
402	2026-05-13 08:17:26+00	2026-05-13 08:17:32.120156+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04339609bc0ae812b81380
403	2026-05-13 08:17:56+00	2026-05-13 08:18:16.150387+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0433b409860ab21282134a
404	2026-05-13 08:18:26+00	2026-05-13 08:19:00.183564+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0433d209860ab21282134a
405	2026-05-13 08:18:56+00	2026-05-13 08:19:00.194659+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0433f009860ab21282134a
406	2026-05-13 08:19:26+00	2026-05-13 08:19:44.008282+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04340e09860ab21282134a
407	2026-05-13 08:19:56+00	2026-05-13 08:20:28.03812+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04342c09860ab21282134a
408	2026-05-13 08:20:26+00	2026-05-13 08:20:28.048494+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04344a09860ab21282134a
409	2026-05-13 08:20:56+00	2026-05-13 08:21:12.090129+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a04346809510a7d124d1315
410	2026-05-13 08:21:26+00	2026-05-13 08:21:56.04277+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a04348609510a7d124d1315
411	2026-05-13 08:21:56+00	2026-05-13 08:22:40.146407+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0434a409860ab21282134a
412	2026-05-13 08:22:26+00	2026-05-13 08:22:40.153192+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0434c209860ab21282134a
413	2026-05-13 08:22:56+00	2026-05-13 08:23:24.146412+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0434e009860ab21282134a
414	2026-05-13 08:23:26+00	2026-05-13 08:24:08.191237+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0434fe09860ab21282134a
415	2026-05-13 08:23:56+00	2026-05-13 08:24:08.199921+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a04351c091b0a47121712df
416	2026-05-13 08:24:26+00	2026-05-13 08:24:52.37147+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04353a09860ab21282134a
417	2026-05-13 08:24:56+00	2026-05-13 08:25:36.247102+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04355809860ab21282134a
418	2026-05-13 08:25:26+00	2026-05-13 08:25:36.260488+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04357609860ab21282134a
419	2026-05-13 08:25:56+00	2026-05-13 08:26:20.320743+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04359409860ab21282134a
420	2026-05-13 08:26:27+00	2026-05-13 08:27:04.320491+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0435b309860ab21282134a
421	2026-05-13 08:26:57+00	2026-05-13 08:27:04.333056+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0435d109860ab21282134a
422	2026-05-13 08:27:27+00	2026-05-13 08:27:48.395001+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0435ef09860ab21282134a
423	2026-05-13 08:27:57+00	2026-05-13 08:28:32.381226+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04360d09860ab21282134a
424	2026-05-13 08:28:27+00	2026-05-13 08:28:32.39227+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04362b09860ab21282134a
425	2026-05-13 08:28:57+00	2026-05-13 08:29:16.3205+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04364909bc0ae812b81380
426	2026-05-13 08:29:27+00	2026-05-13 08:30:00.466933+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04366709860ab21282134a
427	2026-05-13 08:29:57+00	2026-05-13 08:30:00.479012+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04368509860ab21282134a
428	2026-05-13 08:30:27+00	2026-05-13 08:30:44.348694+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0436a309860ab21282134a
429	2026-05-13 08:30:57+00	2026-05-13 08:31:28.420931+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0436c109860ab21282134a
430	2026-05-13 08:31:27+00	2026-05-13 08:31:28.435749+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a0436df091b0a47121712df
431	2026-05-13 08:31:57+00	2026-05-13 08:32:12.581913+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0436fd09bc0ae812b81380
432	2026-05-13 08:32:27+00	2026-05-13 08:32:56.650747+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04371b09860ab21282134a
433	2026-05-13 08:32:57+00	2026-05-13 08:33:40.452247+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04373909860ab21282134a
434	2026-05-13 08:33:27+00	2026-05-13 08:33:40.462873+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04375709860ab21282134a
435	2026-05-13 08:33:57+00	2026-05-13 08:34:24.670383+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04377509860ab21282134a
436	2026-05-13 08:34:27+00	2026-05-13 08:35:08.684057+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04379309860ab21282134a
437	2026-05-13 08:34:57+00	2026-05-13 08:35:08.694041+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0437b109860ab21282134a
438	2026-05-13 08:35:27+00	2026-05-13 08:35:52.494417+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0437cf09860ab21282134a
439	2026-05-13 08:35:57+00	2026-05-13 08:36:36.601618+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0437ed09860ab21282134a
440	2026-05-13 08:36:27+00	2026-05-13 08:36:36.616685+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04380b09860ab21282134a
441	2026-05-13 08:36:57+00	2026-05-13 08:37:20.543135+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04382909860ab21282134a
442	2026-05-13 08:37:27+00	2026-05-13 08:38:04.74939+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04384709860ab21282134a
443	2026-05-13 08:37:58+00	2026-05-13 08:38:04.75892+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04386609860ab21282134a
444	2026-05-13 08:38:29+00	2026-05-13 08:38:48.609354+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04388509860ab21282134a
445	2026-05-13 08:38:59+00	2026-05-13 08:39:32.709142+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0438a309bc0ae812b81380
446	2026-05-13 08:39:29+00	2026-05-13 08:39:32.724836+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0438c109860ab21282134a
447	2026-05-13 08:39:59+00	2026-05-13 08:40:16.620588+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0438df09860ab21282134a
448	2026-05-13 08:40:29+00	2026-05-13 08:41:00.71509+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0438fd09860ab21282134a
449	2026-05-13 08:40:59+00	2026-05-13 08:41:00.733499+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04391b09860ab21282134a
450	2026-05-13 08:41:29+00	2026-05-13 08:41:44.687304+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04393909860ab21282134a
451	2026-05-13 08:41:59+00	2026-05-13 08:42:28.688159+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a04395709510a7d124d1315
452	2026-05-13 08:42:29+00	2026-05-13 08:43:12.862589+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04397509860ab21282134a
453	2026-05-13 08:42:59+00	2026-05-13 08:43:12.882568+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04399309860ab21282134a
454	2026-05-13 08:43:29+00	2026-05-13 08:43:56.866522+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0439b109860ab21282134a
455	2026-05-13 08:43:59+00	2026-05-13 08:44:40.832577+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0439cf09860ab21282134a
456	2026-05-13 08:44:29+00	2026-05-13 08:44:40.858787+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0439ed09860ab21282134a
457	2026-05-13 08:44:59+00	2026-05-13 08:45:24.839031+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043a0b09860ab21282134a
458	2026-05-13 08:45:29+00	2026-05-13 08:46:08.883875+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043a2909860ab21282134a
459	2026-05-13 08:46:00+00	2026-05-13 08:46:08.905125+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043a4809860ab21282134a
460	2026-05-13 08:46:30+00	2026-05-13 08:46:52.833456+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043a6609860ab21282134a
461	2026-05-13 08:47:00+00	2026-05-13 08:47:36.940884+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043a8409860ab21282134a
462	2026-05-13 08:47:30+00	2026-05-13 08:47:36.951347+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043aa209860ab21282134a
463	2026-05-13 08:48:00+00	2026-05-13 08:48:20.938599+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a043ac009bc0ae812b81380
464	2026-05-13 08:48:30+00	2026-05-13 08:49:04.986809+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043ade09860ab21282134a
465	2026-05-13 08:49:00+00	2026-05-13 08:49:05.005151+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043afc09860ab21282134a
466	2026-05-13 08:49:30+00	2026-05-13 08:49:49.023134+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043b1a09860ab21282134a
467	2026-05-13 08:50:00+00	2026-05-13 08:50:33.017417+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043b3809860ab21282134a
468	2026-05-13 08:50:30+00	2026-05-13 08:50:33.029543+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043b5609860ab21282134a
469	2026-05-13 08:51:00+00	2026-05-13 08:51:17.046504+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043b7409860ab21282134a
470	2026-05-13 08:51:30+00	2026-05-13 08:52:01.153179+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043b9209860ab21282134a
471	2026-05-13 08:52:00+00	2026-05-13 08:52:01.173276+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043bb009860ab21282134a
472	2026-05-13 08:52:30+00	2026-05-13 08:52:45.162384+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043bce09860ab21282134a
473	2026-05-13 08:53:00+00	2026-05-13 08:53:29.295158+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043bec09860ab21282134a
474	2026-05-13 08:53:30+00	2026-05-13 08:54:13.244485+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043c0a09860ab21282134a
475	2026-05-13 08:54:00+00	2026-05-13 08:54:13.262626+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043c2809860ab21282134a
476	2026-05-13 08:54:30+00	2026-05-13 08:54:57.084639+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043c4609860ab21282134a
477	2026-05-13 08:55:00+00	2026-05-13 08:55:41.16583+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043c6409860ab21282134a
478	2026-05-13 08:55:30+00	2026-05-13 08:55:41.180395+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043c8209860ab21282134a
479	2026-05-13 08:56:00+00	2026-05-13 08:56:25.157847+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043ca009860ab21282134a
480	2026-05-13 08:56:30+00	2026-05-13 08:57:09.185891+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a043cbe09bc0ae812b81380
481	2026-05-13 08:57:01+00	2026-05-13 08:57:09.202803+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043cdd09860ab21282134a
482	2026-05-13 08:57:31+00	2026-05-13 08:57:53.182316+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043cfb09860ab21282134a
483	2026-05-13 08:58:01+00	2026-05-13 08:58:37.234437+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a043d1909bc0ae812b81380
484	2026-05-13 08:58:31+00	2026-05-13 08:58:37.245454+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043d3709860ab21282134a
485	2026-05-13 08:59:01+00	2026-05-13 08:59:21.260724+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043d5509860ab21282134a
486	2026-05-13 08:59:31+00	2026-05-13 09:00:05.27033+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043d7309860ab21282134a
487	2026-05-13 09:00:01+00	2026-05-13 09:00:05.281758+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043d9109860ab21282134a
488	2026-05-13 09:00:31+00	2026-05-13 09:00:49.256796+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a043daf09bc0ae812b81380
489	2026-05-13 09:01:01+00	2026-05-13 09:01:33.363814+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043dcd09860ab21282134a
490	2026-05-13 09:01:31+00	2026-05-13 09:01:33.37734+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043deb09860ab21282134a
491	2026-05-13 09:02:01+00	2026-05-13 09:02:17.329059+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043e0909860ab21282134a
492	2026-05-13 09:02:31+00	2026-05-13 09:03:01.36277+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043e2709860ab21282134a
493	2026-05-13 09:03:02+00	2026-05-13 09:03:45.389698+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043e4609860ab21282134a
494	2026-05-13 09:03:32+00	2026-05-13 09:03:45.397038+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a043e6409bc0ae812b81380
495	2026-05-13 09:04:02+00	2026-05-13 09:04:29.379674+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043e8209860ab21282134a
496	2026-05-13 09:04:32+00	2026-05-13 09:05:13.416971+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a043ea009bc0ae812b81380
497	2026-05-13 09:05:02+00	2026-05-13 09:05:13.425104+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043ebe09860ab21282134a
498	2026-05-13 09:05:32+00	2026-05-13 09:05:57.460456+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043edc09860ab21282134a
499	2026-05-13 09:06:02+00	2026-05-13 09:06:41.492757+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043efa09860ab21282134a
500	2026-05-13 09:06:32+00	2026-05-13 09:06:41.503598+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043f1809860ab21282134a
501	2026-05-13 09:07:02+00	2026-05-13 09:07:25.475664+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043f3609860ab21282134a
502	2026-05-13 09:07:32+00	2026-05-13 09:08:09.546937+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043f5409860ab21282134a
503	2026-05-13 09:08:03+00	2026-05-13 09:08:09.557278+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043f7309860ab21282134a
504	2026-05-13 09:08:33+00	2026-05-13 09:08:53.569955+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043f9109860ab21282134a
505	2026-05-13 09:09:03+00	2026-05-13 09:09:37.584975+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a043faf09bc0ae812b81380
506	2026-05-13 09:09:33+00	2026-05-13 09:09:37.593022+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a043fcd09860ab21282134a
507	2026-05-13 09:10:03+00	2026-05-13 09:10:21.567083+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a043feb09bc0ae812b81380
508	2026-05-13 09:10:33+00	2026-05-13 09:11:05.637682+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04400909860ab21282134a
509	2026-05-13 09:11:03+00	2026-05-13 09:11:05.647039+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04402709860ab21282134a
510	2026-05-13 09:11:33+00	2026-05-13 09:11:49.655264+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04404509860ab21282134a
511	2026-05-13 09:12:04+00	2026-05-13 09:12:33.653055+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04406409860ab21282134a
512	2026-05-13 09:12:34+00	2026-05-13 09:13:17.702254+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04408209860ab21282134a
513	2026-05-13 09:13:04+00	2026-05-13 09:13:17.709241+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0440a009860ab21282134a
514	2026-05-13 09:13:34+00	2026-05-13 09:14:01.721294+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0440be09860ab21282134a
522	2026-05-13 09:14:04+00	2026-05-13 09:14:13.096093+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0440dc09860ab21282134a
534	2026-05-13 09:14:34+00	2026-05-13 09:14:43.107492+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0440fa09860ab21282134a
546	2026-05-13 09:15:04+00	2026-05-13 09:15:13.106883+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04411809860ab21282134a
558	2026-05-13 09:15:34+00	2026-05-13 09:15:43.117249+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04413609860ab21282134a
570	2026-05-13 09:16:04+00	2026-05-13 09:16:13.165178+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04415409bc0ae812b81380
582	2026-05-13 09:16:34+00	2026-05-13 09:16:43.181313+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04417209860ab21282134a
588	2026-05-13 09:17:04+00	2026-05-13 09:17:45.139309+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04419009860ab21282134a
589	2026-05-13 09:17:34+00	2026-05-13 09:17:45.149732+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0441ae09860ab21282134a
590	2026-05-13 09:18:04+00	2026-05-13 09:18:29.151868+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0441cc09860ab21282134a
591	2026-05-13 09:18:34+00	2026-05-13 09:19:13.179419+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0441ea09bc0ae812b81380
592	2026-05-13 09:19:04+00	2026-05-13 09:19:13.191122+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04420809860ab21282134a
593	2026-05-13 09:19:34+00	2026-05-13 09:19:57.207214+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04422609860ab21282134a
594	2026-05-13 09:20:04+00	2026-05-13 09:20:41.21006+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04424409860ab21282134a
595	2026-05-13 09:20:34+00	2026-05-13 09:20:41.215961+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04426209860ab21282134a
596	2026-05-13 09:21:04+00	2026-05-13 09:21:25.223287+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04428009860ab21282134a
597	2026-05-13 09:23:05+00	2026-05-13 09:23:10.248598+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0442f909f20b1e12ee13b6
598	2026-05-13 09:23:36+00	2026-05-13 09:23:52.626369+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04431809bc0ae812b81380
610	2026-05-13 09:24:06+00	2026-05-13 09:24:14.02052+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04433609bc0ae812b81380
622	2026-05-13 09:24:36+00	2026-05-13 09:24:44.002749+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04435409bc0ae812b81380
634	2026-05-13 09:25:06+00	2026-05-13 09:25:14.02955+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04437209860ab21282134a
646	2026-05-13 09:25:36+00	2026-05-13 09:25:44.033856+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04439009bc0ae812b81380
658	2026-05-13 09:26:06+00	2026-05-13 09:26:14.033913+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0443ae09f20b1e12ee13b6
670	2026-05-13 09:26:36+00	2026-05-13 09:26:44.066476+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0443cc09bc0ae812b81380
671	2026-05-13 09:27:36+00	2026-05-13 09:27:40.12162+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04440809f20b1e12ee13b6
672	2026-05-13 09:28:06+00	2026-05-13 09:28:22.644403+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04442609bc0ae812b81380
673	2026-05-13 09:28:36+00	2026-05-13 09:29:06.648752+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04444409860ab21282134a
674	2026-05-13 09:29:06+00	2026-05-13 09:29:50.681665+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04446209bc0ae812b81380
675	2026-05-13 09:29:36+00	2026-05-13 09:29:50.691911+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04448009bc0ae812b81380
676	2026-05-13 09:30:06+00	2026-05-13 09:30:34.708336+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04449e09860ab21282134a
677	2026-05-13 09:30:36+00	2026-05-13 09:31:18.730179+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0444bc09860ab21282134a
678	2026-05-13 09:31:06+00	2026-05-13 09:31:18.738778+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0444da09860ab21282134a
679	2026-05-13 09:31:36+00	2026-05-13 09:32:02.73419+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0444f809860ab21282134a
680	2026-05-13 09:32:07+00	2026-05-13 09:32:46.793883+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04451709860ab21282134a
681	2026-05-13 09:32:37+00	2026-05-13 09:32:46.807915+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04453509bc0ae812b81380
682	2026-05-13 09:33:07+00	2026-05-13 09:33:31.132354+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04455309f20b1e12ee13b6
683	2026-05-13 09:33:37+00	2026-05-13 09:34:14.876143+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04457109bc0ae812b81380
684	2026-05-13 09:34:07+00	2026-05-13 09:34:14.889266+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04458f09860ab21282134a
685	2026-05-13 09:34:37+00	2026-05-13 09:34:58.823036+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0445ad09860ab21282134a
686	2026-05-13 09:35:07+00	2026-05-13 09:35:42.89392+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0445cb09bc0ae812b81380
687	2026-05-13 09:35:37+00	2026-05-13 09:35:42.903934+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0445e909860ab21282134a
688	2026-05-13 09:36:07+00	2026-05-13 09:36:26.921973+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04460709bc0ae812b81380
689	2026-05-13 09:36:38+00	2026-05-13 09:37:10.946419+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04462609f20b1e12ee13b6
690	2026-05-13 09:37:08+00	2026-05-13 09:37:10.95305+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04464409860ab21282134a
691	2026-05-13 09:37:38+00	2026-05-13 09:37:54.939059+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04466209860ab21282134a
692	2026-05-13 09:38:08+00	2026-05-13 09:38:39.022998+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04468009860ab21282134a
693	2026-05-13 09:38:38+00	2026-05-13 09:38:39.035939+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04469e09bc0ae812b81380
694	2026-05-13 09:39:08+00	2026-05-13 09:39:23.026046+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0446bc09860ab21282134a
695	2026-05-13 09:39:38+00	2026-05-13 09:40:07.068786+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0446da09bc0ae812b81380
696	2026-05-13 09:40:08+00	2026-05-13 09:40:51.147233+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0446f809bc0ae812b81380
697	2026-05-13 09:40:38+00	2026-05-13 09:40:51.162731+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04471609f20b1e12ee13b6
698	2026-05-13 09:41:08+00	2026-05-13 09:41:35.061939+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04473409f20b1e12ee13b6
699	2026-05-13 09:41:38+00	2026-05-13 09:42:19.110597+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04475209860ab21282134a
700	2026-05-13 09:42:08+00	2026-05-13 09:42:19.123631+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04477009860ab21282134a
701	2026-05-13 09:42:38+00	2026-05-13 09:43:03.138758+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04478e09bc0ae812b81380
702	2026-05-13 09:43:08+00	2026-05-13 09:43:47.153635+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0447ac09bc0ae812b81380
703	2026-05-13 09:43:38+00	2026-05-13 09:43:47.169567+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0447ca09bc0ae812b81380
704	2026-05-13 09:44:08+00	2026-05-13 09:44:31.171715+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0447e809f20b1e12ee13b6
705	2026-05-13 09:44:38+00	2026-05-13 09:45:15.222255+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04480609f20b1e12ee13b6
706	2026-05-13 09:45:08+00	2026-05-13 09:45:15.227897+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04482409f20b1e12ee13b6
707	2026-05-13 09:45:39+00	2026-05-13 09:45:59.213179+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04484309bc0ae812b81380
708	2026-05-13 09:46:09+00	2026-05-13 09:46:43.294024+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04486109bc0ae812b81380
709	2026-05-13 09:46:39+00	2026-05-13 09:46:43.300152+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04487f09f20b1e12ee13b6
710	2026-05-13 09:47:09+00	2026-05-13 09:47:27.261044+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04489d09bc0ae812b81380
711	2026-05-13 09:47:39+00	2026-05-13 09:48:11.419854+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0448bb09f20b1e12ee13b6
712	2026-05-13 09:48:09+00	2026-05-13 09:48:11.43056+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0448d909f20b1e12ee13b6
713	2026-05-13 09:48:39+00	2026-05-13 09:48:55.324821+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0448f709bc0ae812b81380
714	2026-05-13 09:49:09+00	2026-05-13 09:49:39.392124+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04491509bc0ae812b81380
715	2026-05-13 09:49:39+00	2026-05-13 09:50:23.400245+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04493309f20b1e12ee13b6
716	2026-05-13 09:50:09+00	2026-05-13 09:50:23.408119+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04495109bc0ae812b81380
717	2026-05-13 09:50:39+00	2026-05-13 09:51:07.402257+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04496f09bc0ae812b81380
718	2026-05-13 09:51:09+00	2026-05-13 09:51:51.440603+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04498d09860ab21282134a
719	2026-05-13 09:51:39+00	2026-05-13 09:51:51.448055+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0449ab09bc0ae812b81380
720	2026-05-13 09:52:09+00	2026-05-13 09:52:35.455098+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0449c909bc0ae812b81380
721	2026-05-13 09:52:39+00	2026-05-13 09:53:19.526757+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0449e709bc0ae812b81380
722	2026-05-13 09:53:09+00	2026-05-13 09:53:19.539723+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044a0509f20b1e12ee13b6
723	2026-05-13 09:53:39+00	2026-05-13 09:54:03.508659+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044a2309bc0ae812b81380
724	2026-05-13 09:54:09+00	2026-05-13 09:54:47.518896+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044a4109bc0ae812b81380
725	2026-05-13 09:54:39+00	2026-05-13 09:54:47.530603+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a044a5f09860ab21282134a
726	2026-05-13 09:55:09+00	2026-05-13 09:55:31.563712+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044a7d09f20b1e12ee13b6
727	2026-05-13 09:55:39+00	2026-05-13 09:56:15.582842+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044a9b09bc0ae812b81380
728	2026-05-13 09:56:09+00	2026-05-13 09:56:15.588968+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044ab909bc0ae812b81380
729	2026-05-13 09:56:39+00	2026-05-13 09:56:59.57721+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044ad709f20b1e12ee13b6
730	2026-05-13 09:57:09+00	2026-05-13 09:57:43.644385+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044af509bc0ae812b81380
731	2026-05-13 09:57:39+00	2026-05-13 09:57:43.657517+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044b1309bc0ae812b81380
732	2026-05-13 09:58:09+00	2026-05-13 09:58:27.632036+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044b3109bc0ae812b81380
733	2026-05-13 09:58:39+00	2026-05-13 09:59:11.723922+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044b4f09f20b1e12ee13b6
734	2026-05-13 09:59:09+00	2026-05-13 09:59:11.733758+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044b6d09bc0ae812b81380
735	2026-05-13 09:59:40+00	2026-05-13 09:59:55.694045+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044b8c09bc0ae812b81380
736	2026-05-13 10:00:10+00	2026-05-13 10:00:39.716668+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044baa09bc0ae812b81380
737	2026-05-13 10:00:40+00	2026-05-13 10:01:23.743015+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044bc809bc0ae812b81380
738	2026-05-13 10:01:10+00	2026-05-13 10:01:23.749779+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044be609bc0ae812b81380
739	2026-05-13 10:01:40+00	2026-05-13 10:02:07.75037+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044c0409bc0ae812b81380
740	2026-05-13 10:02:10+00	2026-05-13 10:02:51.771141+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a044c2209860ab21282134a
741	2026-05-13 10:02:40+00	2026-05-13 10:02:51.777189+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044c4009bc0ae812b81380
742	2026-05-13 10:03:10+00	2026-05-13 10:03:35.777501+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044c5e09bc0ae812b81380
743	2026-05-13 10:03:40+00	2026-05-13 10:04:19.835191+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044c7c09f20b1e12ee13b6
744	2026-05-13 10:04:10+00	2026-05-13 10:04:19.847884+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a044c9a09860ab21282134a
745	2026-05-13 10:04:40+00	2026-05-13 10:05:03.86048+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044cb809bc0ae812b81380
746	2026-05-13 10:05:10+00	2026-05-13 10:05:47.915286+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044cd609bc0ae812b81380
747	2026-05-13 10:05:40+00	2026-05-13 10:05:47.922126+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044cf409f20b1e12ee13b6
748	2026-05-13 10:06:10+00	2026-05-13 10:06:31.925161+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044d1209f20b1e12ee13b6
749	2026-05-13 10:06:40+00	2026-05-13 10:07:15.927904+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044d3009f20b1e12ee13b6
750	2026-05-13 10:07:10+00	2026-05-13 10:07:15.935445+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044d4e09f20b1e12ee13b6
751	2026-05-13 10:07:40+00	2026-05-13 10:07:59.927287+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044d6c09bc0ae812b81380
752	2026-05-13 10:08:10+00	2026-05-13 10:08:43.997405+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044d8a09f20b1e12ee13b6
753	2026-05-13 10:08:40+00	2026-05-13 10:08:44.011265+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044da809bc0ae812b81380
754	2026-05-13 10:09:10+00	2026-05-13 10:09:27.97502+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044dc609f20b1e12ee13b6
755	2026-05-13 10:09:40+00	2026-05-13 10:10:12.04796+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044de409f20b1e12ee13b6
756	2026-05-13 10:10:10+00	2026-05-13 10:10:12.06372+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044e0209bc0ae812b81380
757	2026-05-13 10:10:40+00	2026-05-13 10:10:56.014059+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044e2009bc0ae812b81380
758	2026-05-13 10:11:10+00	2026-05-13 10:11:40.040549+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044e3e09f20b1e12ee13b6
759	2026-05-13 10:11:40+00	2026-05-13 10:12:24.135331+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044e5c09bc0ae812b81380
760	2026-05-13 10:12:10+00	2026-05-13 10:12:24.149058+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044e7a09f20b1e12ee13b6
761	2026-05-13 10:12:41+00	2026-05-13 10:13:08.130925+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a044e9909860ab21282134a
762	2026-05-13 10:13:11+00	2026-05-13 10:13:52.171993+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044eb709f20b1e12ee13b6
763	2026-05-13 10:13:41+00	2026-05-13 10:13:52.181347+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044ed509bc0ae812b81380
764	2026-05-13 10:14:11+00	2026-05-13 10:14:36.158502+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044ef309bc0ae812b81380
765	2026-05-13 10:14:41+00	2026-05-13 10:15:20.279969+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044f1109f20b1e12ee13b6
766	2026-05-13 10:15:11+00	2026-05-13 10:15:20.291774+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044f2f09f20b1e12ee13b6
767	2026-05-13 10:15:41+00	2026-05-13 10:16:04.202001+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044f4d09f20b1e12ee13b6
768	2026-05-13 10:16:11+00	2026-05-13 10:16:48.280224+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044f6b09bc0ae812b81380
769	2026-05-13 10:16:41+00	2026-05-13 10:16:48.293667+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044f8909f20b1e12ee13b6
770	2026-05-13 10:17:11+00	2026-05-13 10:17:32.228311+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a044fa709bc0ae812b81380
771	2026-05-13 10:17:41+00	2026-05-13 10:18:16.360099+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044fc509f20b1e12ee13b6
772	2026-05-13 10:18:11+00	2026-05-13 10:18:16.372247+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a044fe309f20b1e12ee13b6
773	2026-05-13 10:18:41+00	2026-05-13 10:19:00.292506+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04500109bc0ae812b81380
774	2026-05-13 10:19:11+00	2026-05-13 10:19:44.393336+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04501f09bc0ae812b81380
775	2026-05-13 10:19:41+00	2026-05-13 10:19:44.409419+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04503d09f20b1e12ee13b6
776	2026-05-13 10:20:11+00	2026-05-13 10:20:28.355159+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04505b09860ab21282134a
777	2026-05-13 10:20:41+00	2026-05-13 10:21:12.376992+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04507909f20b1e12ee13b6
778	2026-05-13 10:21:11+00	2026-05-13 10:21:12.389904+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04509709f20b1e12ee13b6
779	2026-05-13 10:21:41+00	2026-05-13 10:21:56.39889+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0450b509bc0ae812b81380
780	2026-05-13 10:22:11+00	2026-05-13 10:22:40.537384+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0450d309bc0ae812b81380
781	2026-05-13 10:22:42+00	2026-05-13 10:23:24.490924+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0450f209bc0ae812b81380
782	2026-05-13 10:23:12+00	2026-05-13 10:23:24.497539+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04511009f20b1e12ee13b6
783	2026-05-13 10:23:42+00	2026-05-13 10:24:08.481237+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04512e09f20b1e12ee13b6
791	2026-05-13 10:24:12+00	2026-05-13 10:24:19.867143+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04514c09f20b1e12ee13b6
803	2026-05-13 10:24:42+00	2026-05-13 10:24:49.857802+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04516a09f20b1e12ee13b6
815	2026-05-13 10:25:12+00	2026-05-13 10:25:19.909666+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04518809bc0ae812b81380
827	2026-05-13 10:25:42+00	2026-05-13 10:25:49.93122+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0451a609f20b1e12ee13b6
839	2026-05-13 10:26:12+00	2026-05-13 10:26:19.934117+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0451c409f20b1e12ee13b6
851	2026-05-13 10:26:42+00	2026-05-13 10:26:49.974991+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0451e209f20b1e12ee13b6
863	2026-05-13 10:27:12+00	2026-05-13 10:27:19.975802+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04520009f20b1e12ee13b6
875	2026-05-13 10:27:42+00	2026-05-13 10:27:49.960589+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04521e09bc0ae812b81380
887	2026-05-13 10:28:12+00	2026-05-13 10:28:20.094941+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04523c09bc0ae812b81380
899	2026-05-13 10:28:42+00	2026-05-13 10:28:50.038648+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04525a09f20b1e12ee13b6
911	2026-05-13 10:29:12+00	2026-05-13 10:29:20.133755+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04527809860ab21282134a
923	2026-05-13 10:29:42+00	2026-05-13 10:29:50.056979+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04529609bc0ae812b81380
935	2026-05-13 10:30:12+00	2026-05-13 10:30:20.051964+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0452b409bc0ae812b81380
947	2026-05-13 10:30:42+00	2026-05-13 10:30:50.219979+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0452d209f20b1e12ee13b6
959	2026-05-13 10:31:12+00	2026-05-13 10:31:20.162199+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0452f009f20b1e12ee13b6
971	2026-05-13 10:31:42+00	2026-05-13 10:31:50.140041+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04530e09bc0ae812b81380
983	2026-05-13 10:32:12+00	2026-05-13 10:32:20.086428+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04532c09f20b1e12ee13b6
995	2026-05-13 10:32:42+00	2026-05-13 10:32:50.122217+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04534a09f20b1e12ee13b6
1006	2026-05-13 09:21:34+00	2026-05-13 10:33:20.247072+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04429e09860ab21282134a
1007	2026-05-13 10:33:12+00	2026-05-13 10:33:20.252242+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04536809f20b1e12ee13b6
1008	2026-05-13 09:22:04+00	2026-05-13 10:33:30.123199+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0442bc09bc0ae812b81380
1009	2026-05-13 09:22:34+00	2026-05-13 10:33:30.1386+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0442da09f20b1e12ee13b6
1010	2026-05-13 10:33:43+00	2026-05-13 10:34:12.233782+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04538709f20b1e12ee13b6
1011	2026-05-13 10:34:13+00	2026-05-13 10:34:56.184977+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0453a509f20b1e12ee13b6
1012	2026-05-13 10:34:43+00	2026-05-13 10:34:56.196903+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0453c309f20b1e12ee13b6
1013	2026-05-13 10:35:13+00	2026-05-13 10:35:40.404241+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0453e109bc0ae812b81380
1014	2026-05-13 10:35:43+00	2026-05-13 10:36:24.259827+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0453ff09f20b1e12ee13b6
1015	2026-05-13 10:36:13+00	2026-05-13 10:36:24.277775+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04541d09f20b1e12ee13b6
1016	2026-05-13 10:36:43+00	2026-05-13 10:37:08.288247+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04543b09f20b1e12ee13b6
1017	2026-05-13 10:37:13+00	2026-05-13 10:37:52.226089+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04545909f20b1e12ee13b6
1018	2026-05-13 10:37:43+00	2026-05-13 10:37:52.232375+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04547709bc0ae812b81380
1019	2026-05-13 10:38:13+00	2026-05-13 10:38:36.220629+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04549509bc0ae812b81380
1020	2026-05-13 10:38:43+00	2026-05-13 10:39:20.294701+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0454b309f20b1e12ee13b6
1021	2026-05-13 10:39:14+00	2026-05-13 10:39:20.301639+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0454d209bc0ae812b81380
1022	2026-05-13 10:39:44+00	2026-05-13 10:40:04.421718+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0454f009bc0ae812b81380
1023	2026-05-13 10:40:14+00	2026-05-13 10:40:48.463732+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04550e09bc0ae812b81380
1024	2026-05-13 10:40:44+00	2026-05-13 10:40:48.479422+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04552c09f20b1e12ee13b6
1025	2026-05-13 10:41:14+00	2026-05-13 10:41:32.37355+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04554a09f20b1e12ee13b6
1026	2026-05-13 10:41:44+00	2026-05-13 10:42:16.471183+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04556809f20b1e12ee13b6
1027	2026-05-13 10:42:14+00	2026-05-13 10:42:16.483102+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04558609f20b1e12ee13b6
1028	2026-05-13 10:42:44+00	2026-05-13 10:43:00.370124+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0455a409bc0ae812b81380
1029	2026-05-13 10:43:14+00	2026-05-13 10:43:44.598861+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0455c209bc0ae812b81380
1030	2026-05-13 10:43:44+00	2026-05-13 10:44:28.521087+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0455e009bc0ae812b81380
1031	2026-05-13 10:44:14+00	2026-05-13 10:44:28.531187+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0455fe09f20b1e12ee13b6
1032	2026-05-13 10:44:44+00	2026-05-13 10:45:12.490054+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04561c09f20b1e12ee13b6
1033	2026-05-13 10:45:14+00	2026-05-13 10:45:56.67656+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04563a09f20b1e12ee13b6
1034	2026-05-13 10:45:44+00	2026-05-13 10:45:56.687491+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04565809f20b1e12ee13b6
1035	2026-05-13 10:46:14+00	2026-05-13 10:46:40.704876+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a0456760a280b54132413ec
1036	2026-05-13 10:46:44+00	2026-05-13 10:47:24.631473+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04569409f20b1e12ee13b6
1037	2026-05-13 10:47:14+00	2026-05-13 10:47:24.64487+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0456b209bc0ae812b81380
1038	2026-05-13 10:47:44+00	2026-05-13 10:48:08.554703+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0456d009f20b1e12ee13b6
1039	2026-05-13 10:48:14+00	2026-05-13 10:48:52.605831+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0456ee09bc0ae812b81380
1040	2026-05-13 10:48:44+00	2026-05-13 10:48:52.615316+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04570c09f20b1e12ee13b6
1041	2026-05-13 10:49:14+00	2026-05-13 10:49:36.618011+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04572a09f20b1e12ee13b6
1043	2026-05-13 10:49:44+00	2026-05-13 10:50:20.795904+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04574809f20b1e12ee13b6
1044	2026-05-13 10:50:14+00	2026-05-13 10:50:20.813206+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04576609bc0ae812b81380
1045	2026-05-13 10:50:44+00	2026-05-13 10:51:04.66602+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04578409bc0ae812b81380
1046	2026-05-13 10:51:14+00	2026-05-13 10:51:48.726767+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0457a209860ab21282134a
1047	2026-05-13 10:51:44+00	2026-05-13 10:51:48.735986+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0457c009bc0ae812b81380
1048	2026-05-13 10:52:15+00	2026-05-13 10:52:32.873516+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0457df09bc0ae812b81380
1049	2026-05-13 10:52:45+00	2026-05-13 10:53:16.870494+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0457fd09bc0ae812b81380
1050	2026-05-13 10:53:15+00	2026-05-13 10:53:16.878309+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04581b09f20b1e12ee13b6
1051	2026-05-13 10:53:45+00	2026-05-13 10:54:00.797915+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04583909bc0ae812b81380
1052	2026-05-13 10:54:15+00	2026-05-13 10:54:44.859243+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04585709f20b1e12ee13b6
1053	2026-05-13 10:54:45+00	2026-05-13 10:55:28.857706+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04587509bc0ae812b81380
1054	2026-05-13 10:55:15+00	2026-05-13 10:55:28.87161+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04589309bc0ae812b81380
1055	2026-05-13 10:55:45+00	2026-05-13 10:56:12.979619+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0458b109f20b1e12ee13b6
1056	2026-05-13 10:56:15+00	2026-05-13 10:56:56.876939+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0458cf09860ab21282134a
1057	2026-05-13 10:56:45+00	2026-05-13 10:56:56.889305+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0458ed09f20b1e12ee13b6
1058	2026-05-13 10:57:15+00	2026-05-13 10:57:40.96889+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04590b09bc0ae812b81380
1059	2026-05-13 10:57:45+00	2026-05-13 10:58:25.124384+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04592909f20b1e12ee13b6
1060	2026-05-13 10:58:15+00	2026-05-13 10:58:25.132649+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a04594709860ab21282134a
1061	2026-05-13 10:58:45+00	2026-05-13 10:59:09.261246+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04596509bc0ae812b81380
1062	2026-05-13 10:59:15+00	2026-05-13 10:59:53.034221+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04598309bc0ae812b81380
1063	2026-05-13 10:59:45+00	2026-05-13 10:59:53.047522+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0459a109bc0ae812b81380
1064	2026-05-13 11:00:15+00	2026-05-13 11:00:36.964457+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0459bf09bc0ae812b81380
1065	2026-05-13 11:00:45+00	2026-05-13 11:01:21.112718+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0459dd09f20b1e12ee13b6
1066	2026-05-13 11:01:15+00	2026-05-13 11:01:21.130049+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0459fb09bc0ae812b81380
1067	2026-05-13 11:01:45+00	2026-05-13 11:02:05.243351+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045a1909f20b1e12ee13b6
1068	2026-05-13 11:02:15+00	2026-05-13 11:02:49.255259+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045a3709f20b1e12ee13b6
1069	2026-05-13 11:02:45+00	2026-05-13 11:02:49.272938+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a045a5509860ab21282134a
1070	2026-05-13 11:03:15+00	2026-05-13 11:03:33.560415+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045a7309f20b1e12ee13b6
1071	2026-05-13 11:03:45+00	2026-05-13 11:04:17.178699+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045a9109f20b1e12ee13b6
1072	2026-05-13 11:04:15+00	2026-05-13 11:04:17.193+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045aaf09bc0ae812b81380
1073	2026-05-13 11:04:45+00	2026-05-13 11:05:01.126642+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045acd09bc0ae812b81380
1074	2026-05-13 11:05:16+00	2026-05-13 11:05:45.25828+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045aec09f20b1e12ee13b6
1075	2026-05-13 11:05:46+00	2026-05-13 11:06:29.371901+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045b0a09f20b1e12ee13b6
1076	2026-05-13 11:06:16+00	2026-05-13 11:06:29.386559+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045b2809f20b1e12ee13b6
1077	2026-05-13 11:06:46+00	2026-05-13 11:07:13.39738+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045b4609f20b1e12ee13b6
1078	2026-05-13 11:07:16+00	2026-05-13 11:07:57.284926+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045b6409bc0ae812b81380
1079	2026-05-13 11:07:46+00	2026-05-13 11:07:57.298522+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a045b8209860ab21282134a
1080	2026-05-13 11:08:16+00	2026-05-13 11:08:41.286669+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045ba009f20b1e12ee13b6
1081	2026-05-13 11:08:46+00	2026-05-13 11:09:25.394898+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045bbe09f20b1e12ee13b6
1082	2026-05-13 11:09:16+00	2026-05-13 11:09:25.406308+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045bdc09bc0ae812b81380
1083	2026-05-13 11:09:46+00	2026-05-13 11:10:09.346883+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045bfa09bc0ae812b81380
1084	2026-05-13 11:10:16+00	2026-05-13 11:10:53.465674+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a045c1809860ab21282134a
1085	2026-05-13 11:10:46+00	2026-05-13 11:10:53.475365+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045c3609f20b1e12ee13b6
1086	2026-05-13 11:11:16+00	2026-05-13 11:11:37.347436+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045c5409bc0ae812b81380
1087	2026-05-13 11:11:46+00	2026-05-13 11:12:21.47819+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045c7209f20b1e12ee13b6
1088	2026-05-13 11:12:16+00	2026-05-13 11:12:21.484987+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045c9009bc0ae812b81380
1089	2026-05-13 11:12:46+00	2026-05-13 11:13:05.44417+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045cae09f20b1e12ee13b6
1090	2026-05-13 11:13:16+00	2026-05-13 11:13:49.515217+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045ccc09f20b1e12ee13b6
1091	2026-05-13 11:13:46+00	2026-05-13 11:13:49.524335+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045cea09f20b1e12ee13b6
1092	2026-05-13 11:14:16+00	2026-05-13 11:14:33.512653+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a045d0809860ab21282134a
1093	2026-05-13 11:14:46+00	2026-05-13 11:15:17.592095+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045d2609bc0ae812b81380
1094	2026-05-13 11:15:16+00	2026-05-13 11:15:17.608914+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045d4409f20b1e12ee13b6
1095	2026-05-13 11:15:46+00	2026-05-13 11:16:01.500803+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045d6209bc0ae812b81380
1096	2026-05-13 11:16:16+00	2026-05-13 11:16:45.592068+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045d8009f20b1e12ee13b6
1097	2026-05-13 11:16:46+00	2026-05-13 11:17:29.611018+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045d9e09f20b1e12ee13b6
1098	2026-05-13 11:17:16+00	2026-05-13 11:17:29.617108+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045dbc09f20b1e12ee13b6
1099	2026-05-13 11:17:46+00	2026-05-13 11:18:13.681297+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045dda09f20b1e12ee13b6
1100	2026-05-13 11:18:16+00	2026-05-13 11:18:57.649147+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045df809bc0ae812b81380
1101	2026-05-13 11:18:47+00	2026-05-13 11:18:57.658284+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045e1709bc0ae812b81380
1102	2026-05-13 11:19:17+00	2026-05-13 11:19:41.716276+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045e3509bc0ae812b81380
1103	2026-05-13 11:19:47+00	2026-05-13 11:20:25.714901+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045e5309bc0ae812b81380
1104	2026-05-13 11:20:17+00	2026-05-13 11:20:25.728792+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045e7109f20b1e12ee13b6
1105	2026-05-13 11:20:47+00	2026-05-13 11:21:09.695553+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045e8f09f20b1e12ee13b6
1106	2026-05-13 11:21:17+00	2026-05-13 11:21:53.813219+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045ead09bc0ae812b81380
1107	2026-05-13 11:21:47+00	2026-05-13 11:21:53.819825+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045ecb09bc0ae812b81380
1108	2026-05-13 11:22:17+00	2026-05-13 11:22:37.743982+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045ee909f20b1e12ee13b6
1109	2026-05-13 11:22:47+00	2026-05-13 11:23:21.830817+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045f0709f20b1e12ee13b6
1110	2026-05-13 11:23:17+00	2026-05-13 11:23:21.849606+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045f2509bc0ae812b81380
1111	2026-05-13 11:23:47+00	2026-05-13 11:24:05.832691+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045f4309bc0ae812b81380
1123	2026-05-13 11:24:17+00	2026-05-13 11:24:27.338742+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045f6109f20b1e12ee13b6
1135	2026-05-13 11:24:47+00	2026-05-13 11:24:57.180715+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045f7f09f20b1e12ee13b6
1147	2026-05-13 11:25:17+00	2026-05-13 11:25:27.214948+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045f9d09f20b1e12ee13b6
1159	2026-05-13 11:25:47+00	2026-05-13 11:25:57.248544+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a045fbb09bc0ae812b81380
1171	2026-05-13 11:26:17+00	2026-05-13 11:26:27.361506+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a045fd909f20b1e12ee13b6
1183	2026-05-13 11:26:47+00	2026-05-13 11:26:57.280042+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a045ff709860ab21282134a
1195	2026-05-13 11:27:17+00	2026-05-13 11:27:27.336297+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04601509bc0ae812b81380
1207	2026-05-13 11:27:47+00	2026-05-13 11:27:57.304631+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04603309f20b1e12ee13b6
1219	2026-05-13 11:28:17+00	2026-05-13 11:28:27.387835+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04605109bc0ae812b81380
1231	2026-05-13 11:28:47+00	2026-05-13 11:28:57.348315+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a04606f0a280b54132413ec
1243	2026-05-13 11:29:17+00	2026-05-13 11:29:27.340179+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04608d09f20b1e12ee13b6
1255	2026-05-13 11:29:47+00	2026-05-13 11:29:57.374108+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0460ab09bc0ae812b81380
1267	2026-05-13 11:30:17+00	2026-05-13 11:30:27.539141+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0460c909f20b1e12ee13b6
1279	2026-05-13 11:30:47+00	2026-05-13 11:30:57.497989+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0460e709f20b1e12ee13b6
1291	2026-05-13 11:31:17+00	2026-05-13 11:31:27.699146+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04610509f20b1e12ee13b6
1303	2026-05-13 11:31:47+00	2026-05-13 11:31:57.487034+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04612309f20b1e12ee13b6
1315	2026-05-13 11:32:18+00	2026-05-13 11:32:27.468014+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04614209bc0ae812b81380
1327	2026-05-13 11:32:48+00	2026-05-13 11:32:57.524582+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04616009f20b1e12ee13b6
1337	2026-05-13 11:33:18+00	2026-05-13 11:33:27.527582+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04617e09f20b1e12ee13b6
1338	2026-05-13 11:33:48+00	2026-05-13 11:34:09.48182+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04619c09f20b1e12ee13b6
1339	2026-05-13 11:34:18+00	2026-05-13 11:34:53.490101+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0461ba09f20b1e12ee13b6
1340	2026-05-13 11:34:48+00	2026-05-13 11:34:53.499171+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a0461d80a280b54132413ec
1341	2026-05-13 11:35:18+00	2026-05-13 11:35:37.471095+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a0461f609f20b1e12ee13b6
1342	2026-05-13 11:35:48+00	2026-05-13 11:36:21.479279+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04621409f20b1e12ee13b6
1343	2026-05-13 11:36:18+00	2026-05-13 11:36:21.48664+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04623209f20b1e12ee13b6
1344	2026-05-13 11:36:48+00	2026-05-13 11:37:05.615877+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04625009f20b1e12ee13b6
1345	2026-05-13 11:37:18+00	2026-05-13 11:37:49.61759+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04626e09f20b1e12ee13b6
1346	2026-05-13 11:37:48+00	2026-05-13 11:37:49.625116+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04628c09f20b1e12ee13b6
1347	2026-05-13 11:38:18+00	2026-05-13 11:38:33.613645+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0462aa09bc0ae812b81380
1348	2026-05-13 11:38:48+00	2026-05-13 11:39:17.57351+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a0462c809bc0ae812b81380
1349	2026-05-13 11:39:18+00	2026-05-13 11:40:01.754781+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a0462e609860ab21282134a
1350	2026-05-13 11:39:49+00	2026-05-13 11:40:01.767697+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04630509f20b1e12ee13b6
1351	2026-05-13 11:40:19+00	2026-05-13 11:40:45.870272+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a04632309bc0ae812b81380
1352	2026-05-13 11:40:49+00	2026-05-13 11:41:29.665883+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04634109f20b1e12ee13b6
1353	2026-05-13 11:41:19+00	2026-05-13 11:41:29.675543+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a04635f09f20b1e12ee13b6
1354	2026-05-14 10:24:49+00	2026-05-14 10:25:09.622101+00	ac1f09fffe1acbd5	20.62	23.62	43.62	45.62	6a05a2f1080e093a110a11d2
1355	2026-05-14 10:25:20+00	2026-05-14 10:25:52.12687+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a05a3100843096f11401208
1356	2026-05-14 10:25:50+00	2026-05-14 10:25:52.152879+00	ac1f09fffe1acbd5	20.62	23.62	43.62	45.62	6a05a32e080e093a110a11d2
1357	2026-05-14 10:14:12+00	2026-05-14 10:25:53.480477+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a05a07403a404d00ca00d68
1358	2026-05-14 10:14:43+00	2026-05-14 10:25:53.50241+00	ac1f09fffe1acbd5	9.86	12.86	32.86	34.86	6a05a09303da05060cd60d9e
1359	2026-05-14 10:15:13+00	2026-05-14 10:25:53.524714+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a05a0b1047b05a70d770e3f
1360	2026-05-14 10:15:44+00	2026-05-14 10:25:53.545383+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a05a0d0047b05a70d770e3f
1361	2026-05-14 10:16:14+00	2026-05-14 10:26:03.457407+00	ac1f09fffe1acbd5	12.55	15.55	35.55	37.55	6a05a0ee04e706130de30eab
1362	2026-05-14 10:16:44+00	2026-05-14 10:26:03.468739+00	ac1f09fffe1acbd5	13.62	16.62	36.62	38.62	6a05a10c0552067e0e4e0f16
1363	2026-05-14 10:17:14+00	2026-05-14 10:26:03.48152+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a05a12a05be06ea0eba0f82
1364	2026-05-14 10:17:45+00	2026-05-14 10:26:03.497811+00	ac1f09fffe1acbd5	15.24	18.24	38.24	40.24	6a05a14905f407200ef00fb8
1365	2026-05-14 10:18:16+00	2026-05-14 10:26:13.444496+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a05a16805be06ea0eba0f82
1366	2026-05-14 10:18:46+00	2026-05-14 10:26:13.455906+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a05a186062a07560f260fee
1367	2026-05-14 10:19:16+00	2026-05-14 10:26:13.468463+00	ac1f09fffe1acbd5	16.85	19.85	39.85	41.85	6a05a1a4069507c10f911059
1368	2026-05-14 10:19:47+00	2026-05-14 10:26:13.479187+00	ac1f09fffe1acbd5	16.85	19.85	39.85	41.85	6a05a1c3069507c10f911059
1369	2026-05-14 10:20:17+00	2026-05-14 10:26:23.497514+00	ac1f09fffe1acbd5	17.39	20.39	40.39	42.39	6a05a1e106cb07f70fc7108f
1370	2026-05-14 10:20:47+00	2026-05-14 10:26:23.523516+00	ac1f09fffe1acbd5	17.39	20.39	40.39	42.39	6a05a1ff06cb07f70fc7108f
1371	2026-05-14 10:21:17+00	2026-05-14 10:26:23.545231+00	ac1f09fffe1acbd5	17.93	20.93	40.93	42.93	6a05a21d0701082d0ffd10c5
1372	2026-05-14 10:26:20+00	2026-05-14 10:26:23.563881+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a05a34c0843096f11401208
1373	2026-05-14 10:21:48+00	2026-05-14 10:26:33.449807+00	ac1f09fffe1acbd5	18.47	21.47	41.47	43.47	6a05a23c07370863103310fb
1374	2026-05-14 10:22:18+00	2026-05-14 10:26:33.467284+00	ac1f09fffe1acbd5	19.00	22.00	42.00	44.00	6a05a25a076c089810681130
1375	2026-05-14 10:22:48+00	2026-05-14 10:26:33.486435+00	ac1f09fffe1acbd5	19.00	22.00	42.00	44.00	6a05a278076c089810681130
1376	2026-05-14 10:23:18+00	2026-05-14 10:26:33.5082+00	ac1f09fffe1acbd5	20.08	23.08	43.08	45.08	6a05a29607d8090410d4119c
1377	2026-05-14 10:23:49+00	2026-05-14 10:26:43.455615+00	ac1f09fffe1acbd5	19.54	22.54	42.54	44.54	6a05a2b507a208ce109e1166
1378	2026-05-14 10:24:19+00	2026-05-14 10:26:43.469044+00	ac1f09fffe1acbd5	19.54	22.54	42.54	44.54	6a05a2d307a208ce109e1166
1379	2026-05-14 10:26:50+00	2026-05-14 10:27:25.458995+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a05a36a0843096f11401208
1380	2026-05-14 10:27:21+00	2026-05-14 10:27:25.481106+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a05a3890843096f11401208
1381	2026-05-14 10:27:51+00	2026-05-14 10:28:09.47252+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a05a3a70843096f11401208
1382	2026-05-14 10:28:22+00	2026-05-14 10:28:53.508161+00	ac1f09fffe1acbd5	21.69	24.69	44.69	46.69	6a05a3c6087909a51175123d
1383	2026-05-14 10:28:52+00	2026-05-14 10:28:53.527301+00	ac1f09fffe1acbd5	21.69	24.69	44.69	46.69	6a05a3e4087909a51175123d
1384	2026-05-14 10:29:22+00	2026-05-14 10:29:37.531586+00	ac1f09fffe1acbd5	21.69	24.69	44.69	46.69	6a05a402087909a51175123d
1385	2026-05-14 10:29:53+00	2026-05-14 10:30:21.501787+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a05a42108af09db11ab1273
1386	2026-05-14 10:30:24+00	2026-05-14 10:31:05.550102+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a05a44008af09db11ab1273
1387	2026-05-14 10:30:54+00	2026-05-14 10:31:05.571658+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a05a45e08af09db11ab1273
1388	2026-05-14 10:31:25+00	2026-05-14 10:31:49.582163+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a05a47d08af09db11ab1273
1389	2026-05-14 10:31:55+00	2026-05-14 10:32:33.630951+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a05a49b08af09db11ab1273
1390	2026-05-14 10:32:26+00	2026-05-14 10:32:33.654897+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a05a4ba08af09db11ab1273
1391	2026-05-14 10:32:56+00	2026-05-14 10:33:17.651045+00	ac1f09fffe1acbd5	22.77	25.77	45.77	47.77	6a05a4d808e50a1111e112a9
1392	2026-05-14 10:33:27+00	2026-05-14 10:34:01.682285+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a05a4f708af09db11ab1273
1393	2026-05-14 10:33:57+00	2026-05-14 10:34:01.703936+00	ac1f09fffe1acbd5	22.77	25.77	45.77	47.77	6a05a51508e50a1111e112a9
1394	2026-05-14 10:34:28+00	2026-05-14 10:34:45.624931+00	ac1f09fffe1acbd5	22.77	25.77	45.77	47.77	6a05a53408e50a1111e112a9
1395	2026-05-14 10:34:58+00	2026-05-14 10:35:29.702005+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a552091b0a47121712df
1396	2026-05-14 10:35:29+00	2026-05-14 10:36:13.732137+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a571091b0a47121712df
1397	2026-05-14 10:36:00+00	2026-05-14 10:36:13.749859+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a590091b0a47121712df
1398	2026-05-14 10:36:30+00	2026-05-14 10:36:57.754985+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a5ae091b0a47121712df
1399	2026-05-14 10:37:01+00	2026-05-14 10:37:41.773192+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a5cd091b0a47121712df
1400	2026-05-14 10:37:31+00	2026-05-14 10:37:41.789636+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a5eb091b0a47121712df
1401	2026-05-14 10:38:02+00	2026-05-14 10:38:25.755027+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a60a091b0a47121712df
1402	2026-05-14 10:38:32+00	2026-05-14 10:39:09.835394+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a628091b0a47121712df
1403	2026-05-14 10:39:03+00	2026-05-14 10:39:09.853245+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a647091b0a47121712df
1404	2026-05-14 10:39:33+00	2026-05-14 10:39:53.868881+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a665091b0a47121712df
1405	2026-05-14 10:40:04+00	2026-05-14 10:40:37.856611+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a05a68409510a7d124d1315
1406	2026-05-14 10:40:34+00	2026-05-14 10:40:37.868176+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a6a2091b0a47121712df
1407	2026-05-14 10:41:04+00	2026-05-14 10:41:21.864859+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a6c0091b0a47121712df
1408	2026-05-14 10:41:34+00	2026-05-14 10:42:05.920857+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a6de091b0a47121712df
1409	2026-05-14 10:42:05+00	2026-05-14 10:42:49.956901+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a6fd09860ab21282134a
1410	2026-05-14 10:42:36+00	2026-05-14 10:42:49.968937+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a71c091b0a47121712df
1411	2026-05-14 10:43:06+00	2026-05-14 10:43:34.00368+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a73a09860ab21282134a
1412	2026-05-14 10:43:36+00	2026-05-14 10:44:18.056223+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a758091b0a47121712df
1413	2026-05-14 10:44:07+00	2026-05-14 10:44:18.073958+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a05a77709510a7d124d1315
1414	2026-05-14 10:44:37+00	2026-05-14 10:45:01.999712+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a79509860ab21282134a
1415	2026-05-14 10:45:07+00	2026-05-14 10:45:46.098802+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a05a7b3091b0a47121712df
1416	2026-05-14 10:45:37+00	2026-05-14 10:45:46.120593+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a7d109860ab21282134a
1417	2026-05-14 10:46:07+00	2026-05-14 10:46:30.073805+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a7ef09860ab21282134a
1418	2026-05-14 10:46:37+00	2026-05-14 10:47:14.116988+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a80d09860ab21282134a
1419	2026-05-14 10:47:07+00	2026-05-14 10:47:14.134708+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a82b09860ab21282134a
1420	2026-05-14 10:47:37+00	2026-05-14 10:47:58.119385+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a84909860ab21282134a
1421	2026-05-14 10:48:07+00	2026-05-14 10:48:42.237367+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a86709860ab21282134a
1422	2026-05-14 10:48:37+00	2026-05-14 10:48:42.264826+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a05a88509510a7d124d1315
1423	2026-05-14 10:49:07+00	2026-05-14 10:49:26.18247+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a8a309860ab21282134a
1424	2026-05-14 10:49:38+00	2026-05-14 10:50:10.209049+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a8c209860ab21282134a
1425	2026-05-14 10:50:08+00	2026-05-14 10:50:10.219149+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a05a8e009510a7d124d1315
1426	2026-05-14 10:50:39+00	2026-05-14 10:50:54.251893+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a8ff09860ab21282134a
1427	2026-05-14 10:51:09+00	2026-05-14 10:51:38.201515+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a91d09860ab21282134a
1428	2026-05-14 10:51:39+00	2026-05-14 10:52:22.278417+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a05a93b09510a7d124d1315
1429	2026-05-14 10:52:09+00	2026-05-14 10:52:22.289429+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a95909860ab21282134a
1430	2026-05-14 10:52:39+00	2026-05-14 10:53:06.393987+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a97709860ab21282134a
1431	2026-05-14 10:53:09+00	2026-05-14 10:53:50.348502+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a99509860ab21282134a
1432	2026-05-14 10:53:39+00	2026-05-14 10:53:50.370244+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a9b309860ab21282134a
1433	2026-05-14 10:54:09+00	2026-05-14 10:54:34.308861+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a9d109860ab21282134a
1434	2026-05-14 10:54:39+00	2026-05-14 10:55:18.39748+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05a9ef09860ab21282134a
1435	2026-05-14 10:55:09+00	2026-05-14 10:55:18.413358+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05aa0d09860ab21282134a
1436	2026-05-14 10:55:39+00	2026-05-14 10:56:02.357366+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05aa2b09860ab21282134a
1437	2026-05-14 10:57:09+00	2026-05-14 10:57:30.531342+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05aa8509860ab21282134a
1438	2026-05-14 10:57:39+00	2026-05-14 10:58:14.517812+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05aaa309bc0ae812b81380
1439	2026-05-14 10:58:09+00	2026-05-14 10:58:14.543529+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05aac109860ab21282134a
1455	2026-05-14 10:58:39+00	2026-05-14 10:58:45.893729+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05aadf09860ab21282134a
1467	2026-05-14 10:59:09+00	2026-05-14 10:59:15.955489+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05aafd09860ab21282134a
1479	2026-05-14 10:59:39+00	2026-05-14 10:59:45.944605+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ab1b09860ab21282134a
1491	2026-05-14 11:00:09+00	2026-05-14 11:00:15.937568+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ab3909860ab21282134a
1503	2026-05-14 11:00:39+00	2026-05-14 11:00:45.937727+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ab5709860ab21282134a
1515	2026-05-14 11:01:09+00	2026-05-14 11:01:15.92904+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ab7509860ab21282134a
1527	2026-05-14 11:01:39+00	2026-05-14 11:01:45.979702+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05ab9309bc0ae812b81380
1530	2026-05-14 10:56:09+00	2026-05-14 11:01:55.943505+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05aa4909860ab21282134a
1531	2026-05-14 10:56:39+00	2026-05-14 11:01:55.953611+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05aa6709860ab21282134a
1532	2026-05-14 11:02:09+00	2026-05-14 11:02:37.897738+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05abb109860ab21282134a
1533	2026-05-14 11:02:39+00	2026-05-14 11:03:21.938076+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05abcf09860ab21282134a
1534	2026-05-14 11:03:09+00	2026-05-14 11:03:21.949368+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05abed09860ab21282134a
1535	2026-05-14 11:03:39+00	2026-05-14 11:04:05.986327+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ac0b09860ab21282134a
1536	2026-05-14 11:04:10+00	2026-05-14 11:04:50.022058+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ac2a09860ab21282134a
1537	2026-05-14 11:04:40+00	2026-05-14 11:04:50.04559+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05ac4809bc0ae812b81380
1538	2026-05-14 11:05:10+00	2026-05-14 11:05:33.979005+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ac6609860ab21282134a
1539	2026-05-14 11:05:40+00	2026-05-14 11:06:18.027322+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ac8409860ab21282134a
1540	2026-05-14 11:06:10+00	2026-05-14 11:06:18.03921+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05aca209bc0ae812b81380
1541	2026-05-14 11:06:40+00	2026-05-14 11:07:02.044428+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05acc009860ab21282134a
1542	2026-05-14 11:07:10+00	2026-05-14 11:07:46.142622+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05acde09860ab21282134a
1543	2026-05-14 11:07:40+00	2026-05-14 11:07:46.157454+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05acfc09860ab21282134a
1544	2026-05-14 11:08:10+00	2026-05-14 11:08:30.110596+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05ad1a09bc0ae812b81380
1545	2026-05-14 11:08:40+00	2026-05-14 11:09:14.152479+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05ad3809bc0ae812b81380
1546	2026-05-14 11:09:10+00	2026-05-14 11:09:14.177769+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ad5609860ab21282134a
1547	2026-05-14 11:09:40+00	2026-05-14 11:09:58.17107+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ad7409860ab21282134a
1548	2026-05-14 11:10:10+00	2026-05-14 11:10:42.208124+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ad9209860ab21282134a
1549	2026-05-14 11:10:40+00	2026-05-14 11:10:42.228129+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05adb009860ab21282134a
1550	2026-05-14 11:11:10+00	2026-05-14 11:11:26.190742+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05adce09bc0ae812b81380
1551	2026-05-14 11:11:40+00	2026-05-14 11:12:10.237341+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05adec09bc0ae812b81380
1552	2026-05-14 11:12:10+00	2026-05-14 11:12:54.274191+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05ae0a09bc0ae812b81380
1553	2026-05-14 11:12:40+00	2026-05-14 11:12:54.294089+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ae2809860ab21282134a
1554	2026-05-14 11:13:11+00	2026-05-14 11:13:38.29934+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ae4709860ab21282134a
1555	2026-05-14 11:13:41+00	2026-05-14 11:14:22.319996+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ae6509860ab21282134a
1556	2026-05-14 11:14:11+00	2026-05-14 11:14:22.331942+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05ae8309860ab21282134a
1557	2026-05-14 11:14:41+00	2026-05-14 11:15:06.309891+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05aea109bc0ae812b81380
1558	2026-05-14 11:15:11+00	2026-05-14 11:15:50.360152+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05aebf09bc0ae812b81380
1559	2026-05-14 11:15:41+00	2026-05-14 11:15:50.372399+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05aedd09f20b1e12ee13b6
1560	2026-05-14 11:16:11+00	2026-05-14 11:16:34.398427+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05aefb09bc0ae812b81380
1561	2026-05-14 11:16:41+00	2026-05-14 11:17:18.429527+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05af1909860ab21282134a
1562	2026-05-14 11:17:12+00	2026-05-14 11:17:18.451266+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05af3809860ab21282134a
1563	2026-05-14 11:17:42+00	2026-05-14 11:18:02.3866+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05af5609bc0ae812b81380
1564	2026-05-14 11:18:12+00	2026-05-14 11:18:46.485137+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05af7409860ab21282134a
1565	2026-05-14 11:18:43+00	2026-05-14 11:18:46.504028+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05af9309860ab21282134a
1566	2026-05-14 11:19:13+00	2026-05-14 11:19:30.483265+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05afb109860ab21282134a
1567	2026-05-14 11:20:43+00	2026-05-14 11:20:58.55203+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b00b09860ab21282134a
1568	2026-05-14 11:21:13+00	2026-05-14 11:21:42.523992+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b02909bc0ae812b81380
1576	2026-05-14 11:21:44+00	2026-05-14 11:21:53.898884+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b04809bc0ae812b81380
1588	2026-05-14 11:22:14+00	2026-05-14 11:22:23.988193+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b06609860ab21282134a
1600	2026-05-14 11:22:45+00	2026-05-14 11:22:54.007208+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b08509860ab21282134a
1612	2026-05-14 11:23:15+00	2026-05-14 11:23:23.938471+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b0a309860ab21282134a
1624	2026-05-14 11:23:45+00	2026-05-14 11:23:53.985353+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b0c109860ab21282134a
1636	2026-05-14 11:24:16+00	2026-05-14 11:24:24.008059+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b0e009bc0ae812b81380
1648	2026-05-14 11:24:46+00	2026-05-14 11:24:53.993799+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b0fe09860ab21282134a
1660	2026-05-14 11:25:17+00	2026-05-14 11:25:24.012501+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b11d09bc0ae812b81380
1672	2026-05-14 11:25:47+00	2026-05-14 11:25:54.081339+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b13b09860ab21282134a
1684	2026-05-14 11:26:17+00	2026-05-14 11:26:24.051923+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b15909860ab21282134a
1696	2026-05-14 11:26:48+00	2026-05-14 11:26:54.161231+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b17809860ab21282134a
1708	2026-05-14 11:27:18+00	2026-05-14 11:27:24.121161+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b19609860ab21282134a
1711	2026-05-14 11:19:43+00	2026-05-14 11:27:34.141758+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05afcf09bc0ae812b81380
1712	2026-05-14 11:20:13+00	2026-05-14 11:27:34.158174+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05afed09bc0ae812b81380
1713	2026-05-14 11:27:49+00	2026-05-14 11:28:16.032162+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b1b509bc0ae812b81380
1714	2026-05-14 11:28:19+00	2026-05-14 11:29:00.100305+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b1d309860ab21282134a
1715	2026-05-14 11:28:49+00	2026-05-14 11:29:00.112631+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b1f109860ab21282134a
1716	2026-05-14 11:29:20+00	2026-05-14 11:29:44.127958+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b21009860ab21282134a
1717	2026-05-14 11:29:50+00	2026-05-14 11:30:28.337307+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b22e09860ab21282134a
1718	2026-05-14 11:30:20+00	2026-05-14 11:30:28.348656+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b24c09bc0ae812b81380
1719	2026-05-14 11:30:50+00	2026-05-14 11:31:12.349392+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b26a09bc0ae812b81380
1720	2026-05-14 11:31:21+00	2026-05-14 11:31:56.411915+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b28909bc0ae812b81380
1721	2026-05-14 11:31:51+00	2026-05-14 11:31:56.433159+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b2a709bc0ae812b81380
1722	2026-05-14 11:32:22+00	2026-05-14 11:32:40.466094+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b2c609860ab21282134a
1723	2026-05-14 11:32:53+00	2026-05-14 11:33:44.246073+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b2e509bc0ae812b81380
1724	2026-05-14 11:33:24+00	2026-05-14 11:34:08.476892+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b30409f20b1e12ee13b6
1725	2026-05-14 11:33:54+00	2026-05-14 11:34:08.491575+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b32209f20b1e12ee13b6
1726	2026-05-14 11:34:26+00	2026-05-14 11:34:52.464512+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b34209bc0ae812b81380
1727	2026-05-14 11:34:56+00	2026-05-14 11:35:36.530664+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b36009f20b1e12ee13b6
1728	2026-05-14 11:35:26+00	2026-05-14 11:35:36.555214+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b37e09f20b1e12ee13b6
1729	2026-05-14 11:35:56+00	2026-05-14 11:36:20.508269+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b39c09f20b1e12ee13b6
1730	2026-05-14 11:36:27+00	2026-05-14 11:37:04.58057+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b3bb09860ab21282134a
1731	2026-05-14 11:36:58+00	2026-05-14 11:37:04.593963+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b3da09860ab21282134a
1732	2026-05-14 11:37:28+00	2026-05-14 11:37:48.561003+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b3f809f20b1e12ee13b6
1733	2026-05-14 11:37:58+00	2026-05-14 11:38:32.636914+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b41609860ab21282134a
1734	2026-05-14 11:38:29+00	2026-05-14 11:38:32.646961+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b43509f20b1e12ee13b6
1735	2026-05-14 11:38:59+00	2026-05-14 11:39:16.585326+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b45309bc0ae812b81380
1736	2026-05-14 11:39:29+00	2026-05-14 11:40:00.890149+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b47109bc0ae812b81380
1737	2026-05-14 11:39:59+00	2026-05-14 11:40:00.909241+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b48f09bc0ae812b81380
1738	2026-05-14 11:40:30+00	2026-05-14 11:40:44.888294+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b4ae09bc0ae812b81380
1739	2026-05-14 11:41:00+00	2026-05-14 11:41:28.924902+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b4cc09f20b1e12ee13b6
1740	2026-05-14 11:41:30+00	2026-05-14 11:42:12.930876+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b4ea09bc0ae812b81380
1741	2026-05-14 11:42:01+00	2026-05-14 11:42:12.943613+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b50909bc0ae812b81380
1742	2026-05-14 11:42:31+00	2026-05-14 11:42:56.936556+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b52709f20b1e12ee13b6
1743	2026-05-14 11:43:01+00	2026-05-14 11:43:40.963843+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b54509bc0ae812b81380
1744	2026-05-14 11:43:31+00	2026-05-14 11:43:40.973692+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b56309bc0ae812b81380
1745	2026-05-14 11:44:02+00	2026-05-14 11:44:24.95276+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b58209f20b1e12ee13b6
1746	2026-05-14 11:44:32+00	2026-05-14 11:45:09.015189+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05b5a00a280b54132413ec
1747	2026-05-14 11:45:02+00	2026-05-14 11:45:09.027811+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b5be09f20b1e12ee13b6
1748	2026-05-14 11:45:32+00	2026-05-14 11:45:53.071195+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b5dc09f20b1e12ee13b6
1749	2026-05-14 11:46:02+00	2026-05-14 11:46:37.114092+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b5fa09bc0ae812b81380
1750	2026-05-14 11:46:32+00	2026-05-14 11:46:37.125864+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b61809bc0ae812b81380
1751	2026-05-14 11:47:02+00	2026-05-14 11:47:21.109521+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b63609bc0ae812b81380
1752	2026-05-14 11:47:32+00	2026-05-14 11:48:05.113239+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b65409f20b1e12ee13b6
1753	2026-05-14 11:48:02+00	2026-05-14 11:48:05.129079+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b67209bc0ae812b81380
1754	2026-05-14 11:48:32+00	2026-05-14 11:48:49.154688+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b69009f20b1e12ee13b6
1755	2026-05-14 11:49:02+00	2026-05-14 11:49:33.153969+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b6ae09f20b1e12ee13b6
1756	2026-05-14 11:49:32+00	2026-05-14 11:49:33.164279+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b6cc09f20b1e12ee13b6
1757	2026-05-14 11:50:02+00	2026-05-14 11:50:17.19599+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b6ea09bc0ae812b81380
1758	2026-05-14 11:50:32+00	2026-05-14 11:51:01.183033+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b70809f20b1e12ee13b6
1759	2026-05-14 11:51:02+00	2026-05-14 11:51:45.26553+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b72609bc0ae812b81380
1760	2026-05-14 11:51:32+00	2026-05-14 11:51:45.282803+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b74409f20b1e12ee13b6
1761	2026-05-14 11:52:02+00	2026-05-14 11:52:29.282971+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b76209f20b1e12ee13b6
1762	2026-05-14 11:52:32+00	2026-05-14 11:53:13.326485+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b78009f20b1e12ee13b6
1763	2026-05-14 11:53:02+00	2026-05-14 11:53:13.34261+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b79e09f20b1e12ee13b6
1764	2026-05-14 11:53:32+00	2026-05-14 11:53:57.277756+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b7bc09f20b1e12ee13b6
1765	2026-05-14 11:54:02+00	2026-05-14 11:54:41.389305+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b7da09bc0ae812b81380
1766	2026-05-14 11:54:32+00	2026-05-14 11:54:41.415918+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b7f809f20b1e12ee13b6
1767	2026-05-14 11:55:02+00	2026-05-14 11:55:25.38786+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b81609f20b1e12ee13b6
1768	2026-05-14 11:55:33+00	2026-05-14 11:56:09.499222+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b83509bc0ae812b81380
1769	2026-05-14 11:56:03+00	2026-05-14 11:56:09.508477+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b85309f20b1e12ee13b6
1770	2026-05-14 11:56:33+00	2026-05-14 11:56:53.406871+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b87109f20b1e12ee13b6
1771	2026-05-14 11:57:03+00	2026-05-14 11:57:37.41137+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b88f09bc0ae812b81380
1772	2026-05-14 11:57:33+00	2026-05-14 11:57:37.422028+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b8ad09bc0ae812b81380
1773	2026-05-14 11:58:03+00	2026-05-14 11:58:21.437406+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b8cb09f20b1e12ee13b6
1774	2026-05-14 11:58:33+00	2026-05-14 11:59:05.49812+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b8e909f20b1e12ee13b6
1775	2026-05-14 11:59:03+00	2026-05-14 11:59:05.507402+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b90709f20b1e12ee13b6
1776	2026-05-14 11:59:33+00	2026-05-14 11:59:49.520753+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b92509f20b1e12ee13b6
1777	2026-05-14 12:00:03+00	2026-05-14 12:00:33.513904+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05b94309bc0ae812b81380
1778	2026-05-14 12:00:33+00	2026-05-14 12:01:17.584781+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b96109f20b1e12ee13b6
1779	2026-05-14 12:01:03+00	2026-05-14 12:01:17.595411+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b97f09f20b1e12ee13b6
1780	2026-05-14 12:01:33+00	2026-05-14 12:02:01.581314+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b99d09f20b1e12ee13b6
1781	2026-05-14 12:02:03+00	2026-05-14 12:02:45.584141+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b9bb09f20b1e12ee13b6
1782	2026-05-14 12:02:33+00	2026-05-14 12:02:45.597124+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a05b9d909860ab21282134a
1783	2026-05-14 12:03:03+00	2026-05-14 12:03:29.593831+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05b9f709f20b1e12ee13b6
1784	2026-05-14 12:03:33+00	2026-05-14 12:04:13.686422+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05ba1509f20b1e12ee13b6
1785	2026-05-14 12:04:03+00	2026-05-14 12:04:13.715379+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05ba3309bc0ae812b81380
1786	2026-05-14 12:04:33+00	2026-05-14 12:04:57.665125+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05ba5109f20b1e12ee13b6
1787	2026-05-14 12:05:03+00	2026-05-14 12:05:41.715128+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a05ba6f09bc0ae812b81380
1788	2026-05-14 12:05:33+00	2026-05-14 12:05:41.72567+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05ba8d09f20b1e12ee13b6
1789	2026-05-14 12:06:03+00	2026-05-14 12:06:25.734349+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05baab09f20b1e12ee13b6
1790	2026-05-14 12:06:33+00	2026-05-14 12:07:09.784093+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bac909f20b1e12ee13b6
1791	2026-05-14 12:07:03+00	2026-05-14 12:07:09.808256+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bae709f20b1e12ee13b6
1792	2026-05-14 12:07:33+00	2026-05-14 12:07:53.787461+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bb0509f20b1e12ee13b6
1793	2026-05-14 12:08:04+00	2026-05-14 12:08:37.789358+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bb2409f20b1e12ee13b6
1794	2026-05-14 12:08:34+00	2026-05-14 12:08:37.80308+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bb4209f20b1e12ee13b6
1795	2026-05-14 12:09:04+00	2026-05-14 12:09:21.811446+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bb6009f20b1e12ee13b6
1796	2026-05-14 12:09:34+00	2026-05-14 12:10:05.819875+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bb7e09f20b1e12ee13b6
1797	2026-05-14 12:10:04+00	2026-05-14 12:10:05.83738+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bb9c09f20b1e12ee13b6
1798	2026-05-14 12:10:34+00	2026-05-14 12:10:49.833193+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bbba09f20b1e12ee13b6
1799	2026-05-14 12:11:04+00	2026-05-14 12:11:33.852143+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bbd809f20b1e12ee13b6
1800	2026-05-14 12:11:34+00	2026-05-14 12:12:17.885567+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bbf609f20b1e12ee13b6
1801	2026-05-14 12:12:04+00	2026-05-14 12:12:17.900115+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bc1409f20b1e12ee13b6
1802	2026-05-14 12:12:34+00	2026-05-14 12:13:01.900624+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bc3209f20b1e12ee13b6
1803	2026-05-14 12:13:04+00	2026-05-14 12:13:45.962401+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bc5009f20b1e12ee13b6
1804	2026-05-14 12:13:35+00	2026-05-14 12:13:45.97928+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bc6f09f20b1e12ee13b6
1805	2026-05-14 12:14:05+00	2026-05-14 12:14:29.958235+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bc8d09f20b1e12ee13b6
1806	2026-05-14 12:14:36+00	2026-05-14 12:15:13.966347+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bcac09f20b1e12ee13b6
1807	2026-05-14 12:15:06+00	2026-05-14 12:15:14.001647+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05bcca0a280b54132413ec
1808	2026-05-14 12:15:36+00	2026-05-14 12:15:58.005914+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bce809f20b1e12ee13b6
1809	2026-05-14 12:16:06+00	2026-05-14 12:16:42.026706+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bd0609f20b1e12ee13b6
1810	2026-05-14 12:16:36+00	2026-05-14 12:16:42.037405+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bd2409f20b1e12ee13b6
1811	2026-05-14 12:17:06+00	2026-05-14 12:17:26.068319+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bd4209f20b1e12ee13b6
1812	2026-05-14 12:17:37+00	2026-05-14 12:18:10.121184+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bd6109f20b1e12ee13b6
1813	2026-05-14 12:18:07+00	2026-05-14 12:18:10.143944+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bd7f09f20b1e12ee13b6
1814	2026-05-14 12:18:37+00	2026-05-14 12:18:54.103892+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a05bd9d0a5e0b8a135a1422
1815	2026-05-14 12:19:07+00	2026-05-14 12:19:38.096434+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bdbb09f20b1e12ee13b6
1816	2026-05-14 12:19:38+00	2026-05-14 12:20:22.138585+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bdda09f20b1e12ee13b6
1817	2026-05-14 12:20:08+00	2026-05-14 12:20:22.147924+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a05bdf80a5e0b8a135a1422
1818	2026-05-14 12:20:39+00	2026-05-14 12:21:06.168495+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05be1709f20b1e12ee13b6
1819	2026-05-14 12:21:09+00	2026-05-14 12:21:50.203474+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05be3509f20b1e12ee13b6
1820	2026-05-14 12:21:40+00	2026-05-14 12:21:50.215868+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05be5409f20b1e12ee13b6
1832	2026-05-14 12:22:10+00	2026-05-14 12:22:11.711336+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05be7209f20b1e12ee13b6
1848	2026-05-14 12:22:41+00	2026-05-14 12:22:51.653165+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05be9109f20b1e12ee13b6
1860	2026-05-14 12:23:11+00	2026-05-14 12:23:21.717809+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05beaf09f20b1e12ee13b6
1872	2026-05-14 12:23:42+00	2026-05-14 12:23:51.716538+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05bece0a280b54132413ec
1884	2026-05-14 12:24:12+00	2026-05-14 12:24:21.716896+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05beec09f20b1e12ee13b6
1896	2026-05-14 12:24:42+00	2026-05-14 12:24:51.738292+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05bf0a0a280b54132413ec
1908	2026-05-14 12:25:12+00	2026-05-14 12:25:21.718918+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a05bf280a5e0b8a135a1422
1916	2026-05-14 12:25:42+00	2026-05-14 12:25:51.705053+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bf4609f20b1e12ee13b6
1928	2026-05-14 12:26:12+00	2026-05-14 12:26:21.750207+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bf6409f20b1e12ee13b6
1940	2026-05-14 12:26:43+00	2026-05-14 12:26:51.985327+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05bf830a280b54132413ec
1952	2026-05-14 12:27:13+00	2026-05-14 12:27:22.083519+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bfa109f20b1e12ee13b6
1960	2026-05-14 12:27:44+00	2026-05-14 12:28:23.979326+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bfc009f20b1e12ee13b6
1961	2026-05-14 12:28:14+00	2026-05-14 12:28:23.994398+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05bfde09f20b1e12ee13b6
1962	2026-05-14 12:28:44+00	2026-05-14 12:29:08.002762+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05bffc0a280b54132413ec
1963	2026-05-14 12:29:14+00	2026-05-14 12:29:52.051476+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c01a09f20b1e12ee13b6
1964	2026-05-14 12:29:45+00	2026-05-14 12:29:52.068481+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c03909f20b1e12ee13b6
1965	2026-05-14 12:30:16+00	2026-05-14 12:30:36.015234+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c05809f20b1e12ee13b6
1966	2026-05-14 12:30:46+00	2026-05-14 12:31:20.080862+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c0760a280b54132413ec
1967	2026-05-14 12:31:16+00	2026-05-14 12:31:20.108291+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a05c0940a5e0b8a135a1422
1968	2026-05-14 12:31:47+00	2026-05-14 12:32:04.067945+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c0b309f20b1e12ee13b6
1969	2026-05-14 12:32:17+00	2026-05-14 12:32:48.233558+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c0d109f20b1e12ee13b6
1970	2026-05-14 12:32:47+00	2026-05-14 12:32:48.265751+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c0ef09f20b1e12ee13b6
1971	2026-05-14 12:33:17+00	2026-05-14 12:33:32.251731+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c10d09f20b1e12ee13b6
1972	2026-05-14 12:33:47+00	2026-05-14 12:34:16.22898+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c12b09f20b1e12ee13b6
1973	2026-05-14 12:34:17+00	2026-05-14 12:35:00.305493+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c14909f20b1e12ee13b6
1974	2026-05-14 12:34:48+00	2026-05-14 12:35:00.346472+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c16809f20b1e12ee13b6
1975	2026-05-14 12:35:18+00	2026-05-14 12:35:44.275632+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c18609f20b1e12ee13b6
1976	2026-05-14 12:35:49+00	2026-05-14 12:36:28.332415+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c1a50a280b54132413ec
1977	2026-05-14 12:36:19+00	2026-05-14 12:36:28.352926+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c1c309f20b1e12ee13b6
1978	2026-05-14 12:36:50+00	2026-05-14 12:37:12.360713+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c1e209f20b1e12ee13b6
1979	2026-05-14 12:37:20+00	2026-05-14 12:37:56.428792+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c20009f20b1e12ee13b6
1980	2026-05-14 12:37:50+00	2026-05-14 12:37:56.446845+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c21e09f20b1e12ee13b6
1981	2026-05-14 12:38:20+00	2026-05-14 12:38:40.424684+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c23c09f20b1e12ee13b6
1982	2026-05-14 12:38:51+00	2026-05-14 12:39:24.463857+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c25b09f20b1e12ee13b6
1983	2026-05-14 12:39:22+00	2026-05-14 12:39:24.493252+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c27a09f20b1e12ee13b6
1984	2026-05-14 12:39:52+00	2026-05-14 12:40:08.475842+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c29809f20b1e12ee13b6
1985	2026-05-14 12:40:22+00	2026-05-14 12:40:52.476587+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c2b60a280b54132413ec
1986	2026-05-14 12:40:53+00	2026-05-14 12:41:36.498258+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a05c2d50a5e0b8a135a1422
1987	2026-05-14 12:41:24+00	2026-05-14 12:41:36.520558+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c2f409f20b1e12ee13b6
1988	2026-05-14 12:41:54+00	2026-05-14 12:42:20.525484+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a05c3120a5e0b8a135a1422
1989	2026-05-14 12:42:24+00	2026-05-14 12:43:04.539495+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c3300a280b54132413ec
1990	2026-05-14 12:42:55+00	2026-05-14 12:43:04.549102+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a05c34f0a5e0b8a135a1422
1991	2026-05-14 12:43:25+00	2026-05-14 12:43:48.583378+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c36d09f20b1e12ee13b6
1992	2026-05-14 12:43:56+00	2026-05-14 12:44:32.604142+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c38c0a280b54132413ec
1993	2026-05-14 12:44:26+00	2026-05-14 12:44:32.615949+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c3aa09f20b1e12ee13b6
1994	2026-05-14 12:44:56+00	2026-05-14 12:45:16.582919+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c3c80a280b54132413ec
1995	2026-05-14 12:45:26+00	2026-05-14 12:46:00.619423+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c3e609f20b1e12ee13b6
1996	2026-05-14 12:45:57+00	2026-05-14 12:46:00.629079+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c40509f20b1e12ee13b6
1997	2026-05-14 12:46:27+00	2026-05-14 12:46:44.643756+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c4230a280b54132413ec
1998	2026-05-14 12:46:57+00	2026-05-14 12:47:28.715645+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c4410a280b54132413ec
1999	2026-05-14 12:47:27+00	2026-05-14 12:47:28.729828+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c45f09f20b1e12ee13b6
2000	2026-05-14 12:47:57+00	2026-05-14 12:48:12.691823+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a05c47d0a5e0b8a135a1422
2001	2026-05-14 12:48:27+00	2026-05-14 12:48:56.710242+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c49b09f20b1e12ee13b6
2002	2026-05-14 12:48:57+00	2026-05-14 12:49:40.775248+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c4b909f20b1e12ee13b6
2003	2026-05-14 12:49:27+00	2026-05-14 12:49:40.792241+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c4d70a280b54132413ec
2004	2026-05-14 12:49:57+00	2026-05-14 12:50:24.761054+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a05c4f50a5e0b8a135a1422
2005	2026-05-14 12:50:27+00	2026-05-14 12:51:08.806773+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c51309f20b1e12ee13b6
2006	2026-05-14 12:50:57+00	2026-05-14 12:51:08.818011+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c53109f20b1e12ee13b6
2007	2026-05-14 12:51:27+00	2026-05-14 12:51:52.821739+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c54f09f20b1e12ee13b6
2008	2026-05-14 12:51:57+00	2026-05-14 12:52:36.806791+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c56d0a280b54132413ec
2009	2026-05-14 12:52:27+00	2026-05-14 12:52:36.819552+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c58b09f20b1e12ee13b6
2010	2026-05-14 12:52:57+00	2026-05-14 12:53:20.858895+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c5a909f20b1e12ee13b6
2011	2026-05-14 12:53:27+00	2026-05-14 12:54:04.88159+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c5c709f20b1e12ee13b6
2012	2026-05-14 12:53:57+00	2026-05-14 12:54:04.8916+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c5e50a280b54132413ec
2013	2026-05-14 12:54:27+00	2026-05-14 12:54:48.893249+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c60309f20b1e12ee13b6
2014	2026-05-14 12:54:57+00	2026-05-14 12:55:32.96715+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c62109f20b1e12ee13b6
2015	2026-05-14 12:55:28+00	2026-05-14 12:55:32.987386+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c64009f20b1e12ee13b6
2016	2026-05-14 12:55:58+00	2026-05-14 12:56:16.970305+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a05c65e09f20b1e12ee13b6
2017	2026-05-14 12:56:28+00	2026-05-14 12:57:00.972336+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a05c67c0a5e0b8a135a1422
2018	2026-05-14 12:56:58+00	2026-05-14 12:57:00.985035+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a05c69a0a280b54132413ec
2019	2026-05-15 08:59:44+00	2026-05-15 09:00:26.193678+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a06e080062a07560f260fee
2020	2026-05-15 09:00:14+00	2026-05-15 09:01:10.732659+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a06e09e05be06ea0eba0f82
2021	2026-05-15 09:00:44+00	2026-05-15 09:01:10.754731+00	ac1f09fffe1acbd5	15.24	18.24	38.24	40.24	6a06e0bc05f407200ef00fb8
2022	2026-05-14 22:08:34+00	2026-05-15 09:01:56.114026+00	ac1f09fffe1acbd5	21.69	24.69	44.69	46.69	6a0647e2087909a51175123d
2023	2026-05-14 22:09:04+00	2026-05-15 09:01:56.13451+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a0648000843096f11401208
2024	2026-05-14 22:09:34+00	2026-05-15 09:01:56.148728+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a06481e0843096f11401208
2025	2026-05-14 22:10:05+00	2026-05-15 09:01:56.161007+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06483d08af09db11ab1273
2026	2026-05-14 22:10:35+00	2026-05-15 09:02:06.156607+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06485b08af09db11ab1273
2027	2026-05-14 22:11:05+00	2026-05-15 09:02:06.179059+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06487908af09db11ab1273
2028	2026-05-14 22:11:35+00	2026-05-15 09:02:06.200386+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a0648970843096f11401208
2029	2026-05-15 09:01:44+00	2026-05-15 09:02:06.220248+00	ac1f09fffe1acbd5	14.16	17.16	37.16	39.16	6a06e0f8058806b40e840f4c
2030	2026-05-14 22:12:05+00	2026-05-15 09:02:16.123933+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a0648b508af09db11ab1273
2031	2026-05-14 22:12:35+00	2026-05-15 09:02:16.135352+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a0648d308af09db11ab1273
2032	2026-05-14 22:13:05+00	2026-05-15 09:02:16.145621+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a0648f108af09db11ab1273
2033	2026-05-14 22:13:35+00	2026-05-15 09:02:16.156377+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06490f08af09db11ab1273
2034	2026-05-14 22:14:05+00	2026-05-15 09:02:26.184193+00	ac1f09fffe1acbd5	21.69	24.69	44.69	46.69	6a06492d087909a51175123d
2035	2026-05-14 22:14:35+00	2026-05-15 09:02:26.207026+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06494b08af09db11ab1273
2036	2026-05-14 22:15:05+00	2026-05-15 09:02:26.228605+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06496908af09db11ab1273
2037	2026-05-14 22:15:35+00	2026-05-15 09:02:26.250671+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a0649870843096f11401208
2038	2026-05-14 22:32:37+00	2026-05-15 09:04:06.25287+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a064d8508af09db11ab1273
2039	2026-05-14 22:33:07+00	2026-05-15 09:04:06.270164+00	ac1f09fffe1acbd5	21.69	24.69	44.69	46.69	6a064da3087909a51175123d
2040	2026-05-14 22:33:38+00	2026-05-15 09:04:06.291683+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a064dc208af09db11ab1273
2041	2026-05-15 09:03:45+00	2026-05-15 09:04:06.311976+00	ac1f09fffe1acbd5	13.09	16.09	36.09	38.09	6a06e171051d06490e190ee1
2042	2026-05-14 23:22:12+00	2026-05-15 09:08:36.523228+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06592408af09db11ab1273
2043	2026-05-14 23:22:42+00	2026-05-15 09:08:36.541838+00	ac1f09fffe1acbd5	21.69	24.69	44.69	46.69	6a065942087909a51175123d
2044	2026-05-14 23:23:12+00	2026-05-15 09:08:36.557542+00	ac1f09fffe1acbd5	21.69	24.69	44.69	46.69	6a065960087909a51175123d
2045	2026-05-15 09:08:15+00	2026-05-15 09:08:36.570703+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06e27f047b05a70d770e3f
2046	2026-05-15 09:30:36+00	2026-05-15 09:31:38.245711+00	ac1f09fffe1acbd5	12.55	15.55	35.55	37.55	6a06e7bc04e706130de30eab
2047	2026-05-15 09:31:06+00	2026-05-15 09:32:22.369092+00	ac1f09fffe1acbd5	13.09	16.09	36.09	38.09	6a06e7da051d06490e190ee1
2048	2026-05-15 02:44:05+00	2026-05-15 09:58:08.690007+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06887508af09db11ab1273
2049	2026-05-15 02:44:35+00	2026-05-15 09:58:08.702176+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06889308af09db11ab1273
2050	2026-05-15 02:45:06+00	2026-05-15 09:58:08.716915+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a0688b208af09db11ab1273
2051	2026-05-15 09:57:09+00	2026-05-15 09:58:08.736144+00	ac1f09fffe1acbd5	13.62	16.62	36.62	38.62	6a06edf50552067e0e4e0f16
2052	2026-05-15 02:47:36+00	2026-05-15 09:58:28.6752+00	ac1f09fffe1acbd5	21.69	24.69	44.69	46.69	6a068948087909a51175123d
2053	2026-05-15 02:48:06+00	2026-05-15 09:58:28.69133+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06896608af09db11ab1273
2054	2026-05-15 02:48:36+00	2026-05-15 09:58:28.709611+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06898408af09db11ab1273
2055	2026-05-15 02:49:06+00	2026-05-15 09:58:28.727343+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a0689a20843096f11401208
2056	2026-05-15 03:35:11+00	2026-05-15 10:02:48.784357+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06946f08af09db11ab1273
2057	2026-05-15 03:35:41+00	2026-05-15 10:02:48.803524+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06948d08af09db11ab1273
2058	2026-05-15 03:36:11+00	2026-05-15 10:02:48.82421+00	ac1f09fffe1acbd5	21.69	24.69	44.69	46.69	6a0694ab087909a51175123d
2059	2026-05-15 03:36:41+00	2026-05-15 10:02:48.840558+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a0694c908af09db11ab1273
2060	2026-05-15 03:39:12+00	2026-05-15 10:03:08.746608+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06956008af09db11ab1273
2061	2026-05-15 03:39:42+00	2026-05-15 10:03:08.765369+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06957e08af09db11ab1273
2062	2026-05-15 03:40:12+00	2026-05-15 10:03:08.781621+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06959c08af09db11ab1273
2063	2026-05-15 10:02:09+00	2026-05-15 10:03:08.797686+00	ac1f09fffe1acbd5	12.01	15.01	35.01	37.01	6a06ef2104b105dd0dad0e75
2064	2026-05-15 04:26:47+00	2026-05-15 10:07:28.920282+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06a08708af09db11ab1273
2065	2026-05-15 04:27:17+00	2026-05-15 10:07:28.93597+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06a0a508af09db11ab1273
2066	2026-05-15 04:27:47+00	2026-05-15 10:07:28.953599+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06a0c308af09db11ab1273
2067	2026-05-15 04:28:17+00	2026-05-15 10:07:28.971509+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06a0e108af09db11ab1273
2068	2026-05-15 04:30:17+00	2026-05-15 10:07:48.856352+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06a15908af09db11ab1273
2069	2026-05-15 04:30:48+00	2026-05-15 10:07:48.87572+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06a17808af09db11ab1273
2070	2026-05-15 04:31:18+00	2026-05-15 10:07:48.896211+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06a19608af09db11ab1273
2071	2026-05-15 04:31:48+00	2026-05-15 10:07:48.917047+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a06a1b408af09db11ab1273
2072	2026-05-15 10:44:14+00	2026-05-15 10:44:14.170812+00	ac1f09fffe1acbd5	21.50	24.50	44.50	46.50	6a06f8fe086609921162122a
2073	2026-05-15 10:51:37+00	2026-05-15 11:07:26.659423+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fab90261038d0b5d0c25
2074	2026-05-15 10:52:08+00	2026-05-15 11:08:09.90077+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06fad802cd03f90bc90c91
2075	2026-05-15 10:52:38+00	2026-05-15 11:08:09.926584+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06faf602cd03f90bc90c91
2076	2026-05-15 10:02:39+00	2026-05-15 11:08:12.13928+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06ef3f047b05a70d770e3f
2077	2026-05-15 10:03:09+00	2026-05-15 11:08:12.165682+00	ac1f09fffe1acbd5	12.01	15.01	35.01	37.01	6a06ef5d04b105dd0dad0e75
2078	2026-05-15 10:03:39+00	2026-05-15 11:08:12.187882+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06ef7b047b05a70d770e3f
2079	2026-05-15 10:04:09+00	2026-05-15 11:08:12.202702+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06ef99047b05a70d770e3f
2080	2026-05-15 10:04:39+00	2026-05-15 11:08:22.072494+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06efb7047b05a70d770e3f
2081	2026-05-15 10:05:09+00	2026-05-15 11:08:22.095989+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06efd5047b05a70d770e3f
2082	2026-05-15 10:05:39+00	2026-05-15 11:08:22.120445+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06eff3047b05a70d770e3f
2083	2026-05-15 10:06:09+00	2026-05-15 11:08:22.141233+00	ac1f09fffe1acbd5	12.01	15.01	35.01	37.01	6a06f01104b105dd0dad0e75
2084	2026-05-15 10:06:39+00	2026-05-15 11:08:32.175692+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06f02f047b05a70d770e3f
2085	2026-05-15 10:07:09+00	2026-05-15 11:08:32.194926+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06f04d047b05a70d770e3f
2086	2026-05-15 10:07:39+00	2026-05-15 11:08:32.216373+00	ac1f09fffe1acbd5	10.93	13.93	33.93	35.93	6a06f06b044505710d410e09
2087	2026-05-15 10:08:09+00	2026-05-15 11:08:32.238005+00	ac1f09fffe1acbd5	10.39	13.39	33.40	35.40	6a06f089040f053b0d0c0dd4
2088	2026-05-15 10:08:39+00	2026-05-15 11:08:41.835136+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06f0a7047b05a70d770e3f
2089	2026-05-15 10:09:09+00	2026-05-15 11:08:41.860225+00	ac1f09fffe1acbd5	12.01	15.01	35.01	37.01	6a06f0c504b105dd0dad0e75
2090	2026-05-15 10:09:39+00	2026-05-15 11:08:41.878428+00	ac1f09fffe1acbd5	10.39	13.39	33.40	35.40	6a06f0e3040f053b0d0c0dd4
2091	2026-05-15 10:53:09+00	2026-05-15 11:08:41.898329+00	ac1f09fffe1acbd5	8.24	11.24	31.24	33.24	6a06fb15033804640c340cfc
2092	2026-05-15 10:10:10+00	2026-05-15 11:08:51.70776+00	ac1f09fffe1acbd5	10.39	13.39	33.40	35.40	6a06f102040f053b0d0c0dd4
2093	2026-05-15 10:10:40+00	2026-05-15 11:08:51.71846+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a06f12003a404d00ca00d68
2094	2026-05-15 10:11:10+00	2026-05-15 11:08:51.730238+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a06f13e03a404d00ca00d68
2095	2026-05-15 10:11:40+00	2026-05-15 11:08:51.741732+00	ac1f09fffe1acbd5	8.24	11.24	31.24	33.24	6a06f15c033804640c340cfc
2096	2026-05-15 10:12:10+00	2026-05-15 11:09:01.685196+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06f17a02cd03f90bc90c91
2097	2026-05-15 10:12:40+00	2026-05-15 11:09:01.698449+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06f19802cd03f90bc90c91
2098	2026-05-15 10:13:10+00	2026-05-15 11:09:01.710186+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06f1b602cd03f90bc90c91
2099	2026-05-15 10:13:40+00	2026-05-15 11:09:01.719671+00	ac1f09fffe1acbd5	6.63	9.63	29.63	31.63	6a06f1d4029703c30b930c5b
2100	2026-05-15 10:14:10+00	2026-05-15 11:09:11.705506+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06f1f202cd03f90bc90c91
2101	2026-05-15 10:14:40+00	2026-05-15 11:09:11.719204+00	ac1f09fffe1acbd5	6.63	9.63	29.63	31.63	6a06f210029703c30b930c5b
2102	2026-05-15 10:15:10+00	2026-05-15 11:09:11.733831+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06f22e0261038d0b5d0c25
2103	2026-05-15 10:53:39+00	2026-05-15 11:09:11.751221+00	ac1f09fffe1acbd5	8.78	11.78	31.78	33.78	6a06fb33036e049a0c6a0d32
2104	2026-05-15 10:15:40+00	2026-05-15 11:09:21.704056+00	ac1f09fffe1acbd5	6.63	9.63	29.63	31.63	6a06f24c029703c30b930c5b
2105	2026-05-15 10:16:10+00	2026-05-15 11:09:21.713751+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06f26a0261038d0b5d0c25
2106	2026-05-15 10:16:40+00	2026-05-15 11:09:21.723963+00	ac1f09fffe1acbd5	5.55	8.55	28.55	30.55	6a06f288022b03570b270bef
2107	2026-05-15 10:17:11+00	2026-05-15 11:09:21.737359+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06f2a70261038d0b5d0c25
2108	2026-05-15 10:17:41+00	2026-05-15 11:09:31.698161+00	ac1f09fffe1acbd5	5.55	8.55	28.55	30.55	6a06f2c5022b03570b270bef
2109	2026-05-15 10:18:11+00	2026-05-15 11:09:31.707804+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06f2e30261038d0b5d0c25
2110	2026-05-15 10:18:41+00	2026-05-15 11:09:31.716685+00	ac1f09fffe1acbd5	6.63	9.63	29.63	31.63	6a06f301029703c30b930c5b
2111	2026-05-15 10:19:11+00	2026-05-15 11:09:31.72782+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06f31f02cd03f90bc90c91
2112	2026-05-15 10:19:41+00	2026-05-15 11:09:41.692741+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06f33d02cd03f90bc90c91
2113	2026-05-15 10:20:11+00	2026-05-15 11:09:41.706492+00	ac1f09fffe1acbd5	7.71	10.71	30.71	32.71	6a06f35b0303042f0bff0cc7
2114	2026-05-15 10:20:41+00	2026-05-15 11:09:41.717991+00	ac1f09fffe1acbd5	7.71	10.71	30.71	32.71	6a06f3790303042f0bff0cc7
2115	2026-05-15 10:54:09+00	2026-05-15 11:09:41.729638+00	ac1f09fffe1acbd5	8.78	11.78	31.78	33.78	6a06fb51036e049a0c6a0d32
2116	2026-05-15 10:21:11+00	2026-05-15 11:09:51.724383+00	ac1f09fffe1acbd5	8.24	11.24	31.24	33.24	6a06f397033804640c340cfc
2117	2026-05-15 10:21:41+00	2026-05-15 11:09:51.735464+00	ac1f09fffe1acbd5	8.78	11.78	31.78	33.78	6a06f3b5036e049a0c6a0d32
2118	2026-05-15 10:22:11+00	2026-05-15 11:09:51.749213+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a06f3d303a404d00ca00d68
2119	2026-05-15 10:22:41+00	2026-05-15 11:09:51.760731+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a06f3f103a404d00ca00d68
2120	2026-05-15 10:23:11+00	2026-05-15 11:10:01.696718+00	ac1f09fffe1acbd5	9.86	12.86	32.86	34.86	6a06f40f03da05060cd60d9e
2121	2026-05-15 10:23:41+00	2026-05-15 11:10:01.710312+00	ac1f09fffe1acbd5	10.39	13.39	33.40	35.40	6a06f42d040f053b0d0c0dd4
2122	2026-05-15 10:24:11+00	2026-05-15 11:10:01.724288+00	ac1f09fffe1acbd5	10.39	13.39	33.40	35.40	6a06f44b040f053b0d0c0dd4
2123	2026-05-15 10:24:41+00	2026-05-15 11:10:01.734201+00	ac1f09fffe1acbd5	10.93	13.93	33.93	35.93	6a06f469044505710d410e09
2124	2026-05-15 10:25:11+00	2026-05-15 11:10:11.749935+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06f487047b05a70d770e3f
2125	2026-05-15 10:25:41+00	2026-05-15 11:10:11.771163+00	ac1f09fffe1acbd5	11.47	14.47	34.47	36.47	6a06f4a5047b05a70d770e3f
2126	2026-05-15 10:26:11+00	2026-05-15 11:10:11.79231+00	ac1f09fffe1acbd5	12.01	15.01	35.01	37.01	6a06f4c304b105dd0dad0e75
2127	2026-05-15 10:54:39+00	2026-05-15 11:10:11.817126+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a06fb6f03a404d00ca00d68
2128	2026-05-15 10:26:41+00	2026-05-15 11:10:21.831607+00	ac1f09fffe1acbd5	12.01	15.01	35.01	37.01	6a06f4e104b105dd0dad0e75
2129	2026-05-15 10:27:11+00	2026-05-15 11:10:21.864938+00	ac1f09fffe1acbd5	12.55	15.55	35.55	37.55	6a06f4ff04e706130de30eab
2130	2026-05-15 10:27:41+00	2026-05-15 11:10:21.895527+00	ac1f09fffe1acbd5	12.55	15.55	35.55	37.55	6a06f51d04e706130de30eab
2131	2026-05-15 10:28:11+00	2026-05-15 11:10:21.928625+00	ac1f09fffe1acbd5	13.09	16.09	36.09	38.09	6a06f53b051d06490e190ee1
2132	2026-05-15 10:28:41+00	2026-05-15 11:10:31.756831+00	ac1f09fffe1acbd5	13.62	16.62	36.62	38.62	6a06f5590552067e0e4e0f16
2133	2026-05-15 10:29:11+00	2026-05-15 11:10:31.774421+00	ac1f09fffe1acbd5	13.62	16.62	36.62	38.62	6a06f5770552067e0e4e0f16
2134	2026-05-15 10:29:42+00	2026-05-15 11:10:31.796544+00	ac1f09fffe1acbd5	13.62	16.62	36.62	38.62	6a06f5960552067e0e4e0f16
2135	2026-05-15 10:30:12+00	2026-05-15 11:10:31.820613+00	ac1f09fffe1acbd5	14.16	17.16	37.16	39.16	6a06f5b4058806b40e840f4c
2136	2026-05-15 10:30:42+00	2026-05-15 11:10:41.767138+00	ac1f09fffe1acbd5	14.16	17.16	37.16	39.16	6a06f5d2058806b40e840f4c
2137	2026-05-15 10:31:12+00	2026-05-15 11:10:41.789357+00	ac1f09fffe1acbd5	14.16	17.16	37.16	39.16	6a06f5f0058806b40e840f4c
2138	2026-05-15 10:31:42+00	2026-05-15 11:10:41.804853+00	ac1f09fffe1acbd5	14.16	17.16	37.16	39.16	6a06f60e058806b40e840f4c
2139	2026-05-15 10:55:09+00	2026-05-15 11:10:41.816193+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a06fb8d03a404d00ca00d68
2140	2026-05-15 10:34:12+00	2026-05-15 11:11:01.739176+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a06f6a405be06ea0eba0f82
2141	2026-05-15 10:34:42+00	2026-05-15 11:11:01.74854+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a06f6c205be06ea0eba0f82
2142	2026-05-15 10:35:12+00	2026-05-15 11:11:01.75954+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a06f6e005be06ea0eba0f82
2143	2026-05-15 10:35:42+00	2026-05-15 11:11:01.770592+00	ac1f09fffe1acbd5	15.24	18.24	38.24	40.24	6a06f6fe05f407200ef00fb8
2144	2026-05-15 10:36:12+00	2026-05-15 11:11:11.776834+00	ac1f09fffe1acbd5	15.24	18.24	38.24	40.24	6a06f71c05f407200ef00fb8
2145	2026-05-15 10:36:42+00	2026-05-15 11:11:11.786465+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a06f73a05be06ea0eba0f82
2146	2026-05-15 10:37:12+00	2026-05-15 11:11:11.796793+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a06f758062a07560f260fee
2147	2026-05-15 10:55:39+00	2026-05-15 11:11:11.805403+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a06fbab03a404d00ca00d68
2148	2026-05-15 10:37:42+00	2026-05-15 11:11:21.762006+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a06f776062a07560f260fee
2149	2026-05-15 10:38:12+00	2026-05-15 11:11:21.791409+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a06f794062a07560f260fee
2150	2026-05-15 10:38:42+00	2026-05-15 11:11:21.803432+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a06f7b2062a07560f260fee
2151	2026-05-15 10:39:12+00	2026-05-15 11:11:21.813244+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a06f7d0062a07560f260fee
2152	2026-05-15 10:39:42+00	2026-05-15 11:11:31.976905+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a06f7ee062a07560f260fee
2153	2026-05-15 10:40:12+00	2026-05-15 11:11:31.987799+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a06f80c062a07560f260fee
2154	2026-05-15 10:40:42+00	2026-05-15 11:11:32.000184+00	ac1f09fffe1acbd5	16.31	19.31	39.31	41.31	6a06f82a065f078b0f5b1023
2155	2026-05-15 10:41:12+00	2026-05-15 11:11:32.016334+00	ac1f09fffe1acbd5	16.31	19.31	39.31	41.31	6a06f848065f078b0f5b1023
2156	2026-05-15 10:43:12+00	2026-05-15 11:11:51.776084+00	ac1f09fffe1acbd5	16.85	19.85	39.85	41.85	6a06f8c0069507c10f911059
2157	2026-05-15 10:43:43+00	2026-05-15 11:11:51.789604+00	ac1f09fffe1acbd5	17.39	20.39	40.39	42.39	6a06f8df06cb07f70fc7108f
2158	2026-05-15 10:44:13+00	2026-05-15 11:11:51.803801+00	ac1f09fffe1acbd5	17.39	20.39	40.39	42.39	6a06f8fd06cb07f70fc7108f
2159	2026-05-15 10:44:43+00	2026-05-15 11:11:51.819657+00	ac1f09fffe1acbd5	17.93	20.93	40.93	42.93	6a06f91b0701082d0ffd10c5
2160	2026-05-15 10:45:13+00	2026-05-15 11:12:01.773632+00	ac1f09fffe1acbd5	17.93	20.93	40.93	42.93	6a06f9390701082d0ffd10c5
2161	2026-05-15 10:45:43+00	2026-05-15 11:12:01.789031+00	ac1f09fffe1acbd5	17.93	20.93	40.93	42.93	6a06f9570701082d0ffd10c5
2162	2026-05-15 10:46:13+00	2026-05-15 11:12:01.801477+00	ac1f09fffe1acbd5	17.93	20.93	40.93	42.93	6a06f9750701082d0ffd10c5
2163	2026-05-15 10:46:43+00	2026-05-15 11:12:01.812559+00	ac1f09fffe1acbd5	17.39	20.39	40.39	42.39	6a06f99306cb07f70fc7108f
2164	2026-05-15 10:47:13+00	2026-05-15 11:12:11.888069+00	ac1f09fffe1acbd5	17.93	20.93	40.93	42.93	6a06f9b10701082d0ffd10c5
2165	2026-05-15 10:47:43+00	2026-05-15 11:12:11.89693+00	ac1f09fffe1acbd5	17.93	20.93	40.93	42.93	6a06f9cf0701082d0ffd10c5
2166	2026-05-15 10:48:13+00	2026-05-15 11:12:11.907997+00	ac1f09fffe1acbd5	16.85	19.85	39.85	41.85	6a06f9ed069507c10f911059
2167	2026-05-15 10:56:39+00	2026-05-15 11:12:11.920153+00	ac1f09fffe1acbd5	8.78	11.78	31.78	33.78	6a06fbe7036e049a0c6a0d32
2168	2026-05-15 10:48:43+00	2026-05-15 11:12:21.844314+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a06fa0b062a07560f260fee
2169	2026-05-15 10:49:13+00	2026-05-15 11:12:21.863833+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a06fa29062a07560f260fee
2170	2026-05-15 10:49:43+00	2026-05-15 11:12:21.885381+00	ac1f09fffe1acbd5	15.24	18.24	38.24	40.24	6a06fa4705f407200ef00fb8
2171	2026-05-15 10:50:13+00	2026-05-15 11:12:21.903208+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a06fa6505be06ea0eba0f82
2172	2026-05-15 10:50:36+00	2026-05-15 11:12:31.868333+00	ac1f09fffe1acbd5	5.55	8.55	28.55	30.55	6a06fa7c022b03570b270bef
2173	2026-05-15 10:51:06+00	2026-05-15 11:12:31.893877+00	ac1f09fffe1acbd5	5.01	8.02	28.02	30.02	6a06fa9a01f503220af20bba
2174	2026-05-15 10:57:09+00	2026-05-15 11:13:13.72399+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a06fc0503a404d00ca00d68
2175	2026-05-15 10:57:39+00	2026-05-15 11:13:13.745201+00	ac1f09fffe1acbd5	8.24	11.24	31.24	33.24	6a06fc23033804640c340cfc
2176	2026-05-15 10:58:09+00	2026-05-15 11:13:57.788369+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06fc4102cd03f90bc90c91
2177	2026-05-15 10:58:39+00	2026-05-15 11:14:41.765227+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fc5f0261038d0b5d0c25
2178	2026-05-15 10:59:09+00	2026-05-15 11:14:41.777621+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fc7d0261038d0b5d0c25
2179	2026-05-15 10:59:39+00	2026-05-15 11:15:25.801505+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fc9b0261038d0b5d0c25
2180	2026-05-15 11:00:09+00	2026-05-15 11:16:09.869318+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fcb90261038d0b5d0c25
2181	2026-05-15 11:00:39+00	2026-05-15 11:16:09.882442+00	ac1f09fffe1acbd5	6.63	9.63	29.63	31.63	6a06fcd7029703c30b930c5b
2182	2026-05-15 11:01:09+00	2026-05-15 11:16:53.779766+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06fcf502cd03f90bc90c91
2183	2026-05-15 11:01:39+00	2026-05-15 11:17:37.795162+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fd130261038d0b5d0c25
2184	2026-05-15 11:02:09+00	2026-05-15 11:18:21.830151+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fd310261038d0b5d0c25
2185	2026-05-15 11:02:39+00	2026-05-15 11:18:21.839633+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fd4f0261038d0b5d0c25
2205	2026-05-15 11:03:39+00	2026-05-15 11:19:13.77359+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fd8b0261038d0b5d0c25
2217	2026-05-15 11:04:09+00	2026-05-15 11:19:43.738348+00	ac1f09fffe1acbd5	5.55	8.55	28.55	30.55	6a06fda9022b03570b270bef
2229	2026-05-15 11:04:39+00	2026-05-15 11:20:13.696588+00	ac1f09fffe1acbd5	5.01	8.02	28.02	30.02	6a06fdc701f503220af20bba
2241	2026-05-15 11:05:09+00	2026-05-15 11:20:43.725397+00	ac1f09fffe1acbd5	5.55	8.55	28.55	30.55	6a06fde5022b03570b270bef
2246	2026-05-15 10:32:12+00	2026-05-15 11:21:03.766861+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a06f62c05be06ea0eba0f82
2247	2026-05-15 10:32:42+00	2026-05-15 11:21:03.779166+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a06f64a05be06ea0eba0f82
2248	2026-05-15 10:33:12+00	2026-05-15 11:21:03.788429+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a06f66805be06ea0eba0f82
2249	2026-05-15 10:33:42+00	2026-05-15 11:21:03.796651+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a06f68605be06ea0eba0f82
2253	2026-05-15 11:05:40+00	2026-05-15 11:21:13.779809+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fe040261038d0b5d0c25
2265	2026-05-15 11:06:10+00	2026-05-15 11:21:43.75603+00	ac1f09fffe1acbd5	5.55	8.55	28.55	30.55	6a06fe22022b03570b270bef
2267	2026-05-15 10:41:42+00	2026-05-15 11:21:53.771464+00	ac1f09fffe1acbd5	16.85	19.85	39.85	41.85	6a06f866069507c10f911059
2268	2026-05-15 10:42:12+00	2026-05-15 11:21:53.781229+00	ac1f09fffe1acbd5	16.85	19.85	39.85	41.85	6a06f884069507c10f911059
2269	2026-05-15 10:42:42+00	2026-05-15 11:21:53.789929+00	ac1f09fffe1acbd5	17.39	20.39	40.39	42.39	6a06f8a206cb07f70fc7108f
2277	2026-05-15 11:06:40+00	2026-05-15 11:22:13.764389+00	ac1f09fffe1acbd5	5.01	8.02	28.02	30.02	6a06fe4001f503220af20bba
2283	2026-05-15 10:50:43+00	2026-05-15 11:22:43.747046+00	ac1f09fffe1acbd5	14.16	17.16	37.16	39.16	6a06fa83058806b40e840f4c
2284	2026-05-15 11:07:10+00	2026-05-15 11:22:43.774264+00	ac1f09fffe1acbd5	5.01	8.02	28.02	30.02	6a06fe5e01f503220af20bba
2285	2026-05-15 10:51:13+00	2026-05-15 11:22:53.633112+00	ac1f09fffe1acbd5	14.16	17.16	37.16	39.16	6a06faa1058806b40e840f4c
2286	2026-05-15 11:07:40+00	2026-05-15 11:23:35.659757+00	ac1f09fffe1acbd5	5.01	8.02	28.02	30.02	6a06fe7c01f503220af20bba
2287	2026-05-15 11:08:10+00	2026-05-15 11:24:19.627868+00	ac1f09fffe1acbd5	4.48	7.48	27.48	29.48	6a06fe9a01c002ec0abc0b84
2288	2026-05-15 11:08:40+00	2026-05-15 11:24:19.64115+00	ac1f09fffe1acbd5	5.01	8.02	28.02	30.02	6a06feb801f503220af20bba
2289	2026-05-15 11:09:10+00	2026-05-15 11:25:03.826318+00	ac1f09fffe1acbd5	5.01	8.02	28.02	30.02	6a06fed601f503220af20bba
2290	2026-05-15 11:09:40+00	2026-05-15 11:25:47.754019+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06fef40261038d0b5d0c25
2291	2026-05-15 11:10:10+00	2026-05-15 11:25:47.774625+00	ac1f09fffe1acbd5	6.09	9.09	29.09	31.09	6a06ff120261038d0b5d0c25
2292	2026-05-15 11:10:40+00	2026-05-15 11:26:31.785226+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06ff3002cd03f90bc90c91
2293	2026-05-15 11:11:10+00	2026-05-15 11:27:15.770174+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06ff4e02cd03f90bc90c91
2294	2026-05-15 11:11:40+00	2026-05-15 11:27:15.786835+00	ac1f09fffe1acbd5	6.63	9.63	29.63	31.63	6a06ff6c029703c30b930c5b
2295	2026-05-15 11:12:10+00	2026-05-15 11:27:59.690175+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06ff8a02cd03f90bc90c91
2296	2026-05-15 11:12:40+00	2026-05-15 11:28:43.781744+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a06ffa802cd03f90bc90c91
2297	2026-05-15 11:13:10+00	2026-05-15 11:28:43.79669+00	ac1f09fffe1acbd5	8.78	11.78	31.78	33.78	6a06ffc6036e049a0c6a0d32
2298	2026-05-15 11:13:40+00	2026-05-15 11:29:27.751534+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a06ffe403a404d00ca00d68
2299	2026-05-15 11:14:10+00	2026-05-15 11:30:11.78399+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a07000203a404d00ca00d68
2300	2026-05-15 11:14:40+00	2026-05-15 11:30:11.792272+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a07002003a404d00ca00d68
2301	2026-05-15 11:15:10+00	2026-05-15 11:30:55.780218+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a07003e03a404d00ca00d68
2302	2026-05-15 11:15:40+00	2026-05-15 11:31:39.827268+00	ac1f09fffe1acbd5	8.24	11.24	31.24	33.24	6a07005c033804640c340cfc
2303	2026-05-15 11:16:10+00	2026-05-15 11:32:23.916556+00	ac1f09fffe1acbd5	8.24	11.24	31.24	33.24	6a07007a033804640c340cfc
2304	2026-05-15 11:16:40+00	2026-05-15 11:32:23.93023+00	ac1f09fffe1acbd5	8.24	11.24	31.24	33.24	6a070098033804640c340cfc
2305	2026-05-15 11:17:10+00	2026-05-15 11:33:07.878508+00	ac1f09fffe1acbd5	8.78	11.78	31.78	33.78	6a0700b6036e049a0c6a0d32
2306	2026-05-15 11:18:41+00	2026-05-15 11:34:35.95638+00	ac1f09fffe1acbd5	7.71	10.71	30.71	32.71	6a0701110303042f0bff0cc7
2307	2026-05-15 11:19:11+00	2026-05-15 11:35:19.997696+00	ac1f09fffe1acbd5	8.24	11.24	31.24	33.24	6a07012f033804640c340cfc
2308	2026-05-15 11:19:41+00	2026-05-15 11:35:20.007775+00	ac1f09fffe1acbd5	7.71	10.71	30.71	32.71	6a07014d0303042f0bff0cc7
2309	2026-05-15 11:17:41+00	2026-05-15 11:35:21.69735+00	ac1f09fffe1acbd5	8.78	11.78	31.78	33.78	6a0700d5036e049a0c6a0d32
2310	2026-05-15 11:18:11+00	2026-05-15 11:35:21.708387+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a0700f303a404d00ca00d68
2311	2026-05-15 11:40:19+00	2026-05-15 11:40:31.068538+00	ac1f09fffe1acbd5	5.55	8.55	28.55	30.55	6a070623022b03570b270bef
2312	2026-05-15 11:40:49+00	2026-05-15 11:41:13.610903+00	ac1f09fffe1acbd5	7.17	10.17	30.17	32.17	6a07064102cd03f90bc90c91
2313	2026-05-15 11:19:49+00	2026-05-15 11:41:14.931381+00	ac1f09fffe1acbd5	5.01	8.02	28.02	30.02	6a07015501f503220af20bba
2314	2026-05-15 11:39:48+00	2026-05-15 11:41:14.95216+00	ac1f09fffe1acbd5	5.01	8.02	28.02	30.02	6a07060401f503220af20bba
2315	2026-05-15 11:41:20+00	2026-05-15 11:41:56.899159+00	ac1f09fffe1acbd5	8.24	11.24	31.24	33.24	6a070660033804640c340cfc
2316	2026-05-15 11:41:50+00	2026-05-15 11:41:56.908349+00	ac1f09fffe1acbd5	9.32	12.32	32.32	34.32	6a07067e03a404d00ca00d68
2317	2026-05-15 11:42:20+00	2026-05-15 11:42:40.927702+00	ac1f09fffe1acbd5	10.93	13.93	33.93	35.93	6a07069c044505710d410e09
2318	2026-05-15 11:42:50+00	2026-05-15 11:43:24.973526+00	ac1f09fffe1acbd5	12.01	15.01	35.01	37.01	6a0706ba04b105dd0dad0e75
2319	2026-05-15 11:43:20+00	2026-05-15 11:43:24.982077+00	ac1f09fffe1acbd5	12.01	15.01	35.01	37.01	6a0706d804b105dd0dad0e75
2320	2026-05-15 11:43:50+00	2026-05-15 11:44:08.945967+00	ac1f09fffe1acbd5	13.62	16.62	36.62	38.62	6a0706f60552067e0e4e0f16
2321	2026-05-15 11:44:20+00	2026-05-15 11:44:53.011479+00	ac1f09fffe1acbd5	13.62	16.62	36.62	38.62	6a0707140552067e0e4e0f16
2322	2026-05-15 11:44:51+00	2026-05-15 11:44:53.021346+00	ac1f09fffe1acbd5	14.70	17.70	37.70	39.70	6a07073305be06ea0eba0f82
2323	2026-05-15 11:45:21+00	2026-05-15 11:45:37.00774+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a070751062a07560f260fee
2324	2026-05-15 11:45:51+00	2026-05-15 11:46:21.040715+00	ac1f09fffe1acbd5	15.78	18.78	38.78	40.78	6a07076f062a07560f260fee
2325	2026-05-15 11:46:21+00	2026-05-15 11:46:21.050106+00	ac1f09fffe1acbd5	16.31	19.31	39.31	41.31	6a07078d065f078b0f5b1023
2326	2026-05-15 11:46:51+00	2026-05-15 11:47:05.069263+00	ac1f09fffe1acbd5	16.85	19.85	39.85	41.85	6a0707ab069507c10f911059
2327	2026-05-15 11:47:21+00	2026-05-15 11:47:49.098008+00	ac1f09fffe1acbd5	16.85	19.85	39.85	41.85	6a0707c9069507c10f911059
2328	2026-05-15 11:47:51+00	2026-05-15 11:48:33.108562+00	ac1f09fffe1acbd5	17.93	20.93	40.93	42.93	6a0707e70701082d0ffd10c5
2329	2026-05-15 11:48:21+00	2026-05-15 11:48:33.119273+00	ac1f09fffe1acbd5	18.47	21.47	41.47	43.47	6a07080507370863103310fb
2330	2026-05-15 11:48:51+00	2026-05-15 11:49:17.147808+00	ac1f09fffe1acbd5	19.00	22.00	42.00	44.00	6a070823076c089810681130
2331	2026-05-15 11:49:21+00	2026-05-15 11:50:01.196247+00	ac1f09fffe1acbd5	19.00	22.00	42.00	44.00	6a070841076c089810681130
2332	2026-05-15 11:49:51+00	2026-05-15 11:50:01.210801+00	ac1f09fffe1acbd5	19.54	22.54	42.54	44.54	6a07085f07a208ce109e1166
2333	2026-05-15 11:50:51+00	2026-05-15 11:51:29.269134+00	ac1f09fffe1acbd5	20.08	23.08	43.08	45.08	6a07089b07d8090410d4119c
2334	2026-05-15 11:51:21+00	2026-05-15 11:51:29.278507+00	ac1f09fffe1acbd5	20.08	23.08	43.08	45.08	6a0708b907d8090410d4119c
2337	2026-05-15 11:51:51+00	2026-05-15 11:52:12.523793+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a0708d70843096f11401208
2338	2026-05-15 11:52:21+00	2026-05-15 11:52:56.596264+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a0708f50843096f11401208
2339	2026-05-15 11:52:51+00	2026-05-15 11:52:56.60698+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a0709130843096f11401208
2340	2026-05-15 11:53:21+00	2026-05-15 11:53:40.596261+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a07093108af09db11ab1273
2341	2026-05-15 11:53:51+00	2026-05-15 11:54:24.664272+00	ac1f09fffe1acbd5	21.15	24.15	44.16	46.16	6a07094f0843096f11401208
2342	2026-05-15 11:54:21+00	2026-05-15 11:54:24.682604+00	ac1f09fffe1acbd5	22.23	25.23	45.23	47.23	6a07096d08af09db11ab1273
2343	2026-05-15 11:54:51+00	2026-05-15 11:55:08.607181+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a07098b091b0a47121712df
2344	2026-05-15 11:55:21+00	2026-05-15 11:55:52.680787+00	ac1f09fffe1acbd5	22.77	25.77	45.77	47.77	6a0709a908e50a1111e112a9
2345	2026-05-15 11:55:51+00	2026-05-15 11:55:52.689555+00	ac1f09fffe1acbd5	22.77	25.77	45.77	47.77	6a0709c708e50a1111e112a9
2346	2026-05-15 11:56:21+00	2026-05-15 11:56:36.689993+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a0709e5091b0a47121712df
2347	2026-05-15 11:56:51+00	2026-05-15 11:57:20.756033+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a070a03091b0a47121712df
2348	2026-05-15 11:57:21+00	2026-05-15 11:58:04.784357+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a070a21091b0a47121712df
2349	2026-05-15 11:57:51+00	2026-05-15 11:58:04.794932+00	ac1f09fffe1acbd5	22.77	25.77	45.77	47.77	6a070a3f08e50a1111e112a9
2350	2026-05-15 11:58:21+00	2026-05-15 11:58:48.740394+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a070a5d091b0a47121712df
2351	2026-05-15 11:58:52+00	2026-05-15 11:59:32.817646+00	ac1f09fffe1acbd5	23.31	26.31	46.31	48.31	6a070a7c091b0a47121712df
2352	2026-05-15 11:59:22+00	2026-05-15 11:59:32.831662+00	ac1f09fffe1acbd5	23.85	26.85	46.85	48.85	6a070a9a09510a7d124d1315
2353	2026-05-15 11:59:52+00	2026-05-15 12:00:16.797681+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a070ab809860ab21282134a
2354	2026-05-15 12:00:22+00	2026-05-15 12:01:00.861136+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a070ad609860ab21282134a
2355	2026-05-15 12:00:52+00	2026-05-15 12:01:00.869818+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a070af409860ab21282134a
2356	2026-05-15 12:01:22+00	2026-05-15 12:01:44.851786+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a070b1209860ab21282134a
2357	2026-05-15 12:01:52+00	2026-05-15 12:02:28.890465+00	ac1f09fffe1acbd5	24.38	27.38	47.38	49.38	6a070b3009860ab21282134a
2358	2026-05-15 12:02:22+00	2026-05-15 12:02:28.898241+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a070b4e09f20b1e12ee13b6
2370	2026-05-15 12:02:52+00	2026-05-15 12:03:00.261728+00	ac1f09fffe1acbd5	24.92	27.92	47.92	49.92	6a070b6c09bc0ae812b81380
2374	2026-05-15 11:50:21+00	2026-05-15 12:03:20.306226+00	ac1f09fffe1acbd5	20.08	23.08	43.08	45.08	6a07087d07d8090410d4119c
2376	2026-05-15 12:03:22+00	2026-05-15 12:03:30.268321+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a070b8a09f20b1e12ee13b6
2377	2026-05-15 12:03:52+00	2026-05-15 12:04:12.221833+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a070ba809f20b1e12ee13b6
2378	2026-05-15 12:04:22+00	2026-05-15 12:04:56.271241+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a070bc609f20b1e12ee13b6
2379	2026-05-15 12:04:52+00	2026-05-15 12:04:56.28555+00	ac1f09fffe1acbd5	25.46	28.46	48.46	50.46	6a070be409f20b1e12ee13b6
2380	2026-05-15 12:05:22+00	2026-05-15 12:05:40.269671+00	ac1f09fffe1acbd5	26.00	29.00	49.00	51.00	6a070c020a280b54132413ec
2381	2026-05-15 12:05:52+00	2026-05-15 12:06:24.311553+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a070c200a5e0b8a135a1422
2382	2026-05-15 12:06:22+00	2026-05-15 12:06:24.320601+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a070c3e0a5e0b8a135a1422
2383	2026-05-15 12:06:52+00	2026-05-15 12:07:08.337542+00	ac1f09fffe1acbd5	26.54	29.54	49.54	51.54	6a070c5c0a5e0b8a135a1422
\.


--
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_user
--

SELECT pg_catalog.setval('public.audit_log_id_seq', 143, true);


--
-- Name: lora_uplink_metadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_user
--

SELECT pg_catalog.setval('public.lora_uplink_metadata_id_seq', 121, true);


--
-- Name: sensor_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app_user
--

SELECT pg_catalog.setval('public.sensor_data_id_seq', 2383, true);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: app_user
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: end_devices dev_eui_unique; Type: CONSTRAINT; Schema: public; Owner: app_user
--

ALTER TABLE ONLY public.end_devices
    ADD CONSTRAINT dev_eui_unique PRIMARY KEY (dev_eui);


--
-- Name: lora_uplink_metadata lora_uplink_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: app_user
--

ALTER TABLE ONLY public.lora_uplink_metadata
    ADD CONSTRAINT lora_uplink_metadata_pkey PRIMARY KEY (id);


--
-- Name: pending_recovery pending_recovery_pkey; Type: CONSTRAINT; Schema: public; Owner: app_user
--

ALTER TABLE ONLY public.pending_recovery
    ADD CONSTRAINT pending_recovery_pkey PRIMARY KEY (device_eui);


--
-- Name: sensor_data sensor_data_pkey; Type: CONSTRAINT; Schema: public; Owner: app_user
--

ALTER TABLE ONLY public.sensor_data
    ADD CONSTRAINT sensor_data_pkey PRIMARY KEY (id);


--
-- Name: sensor_data unique_measurement; Type: CONSTRAINT; Schema: public; Owner: app_user
--

ALTER TABLE ONLY public.sensor_data
    ADD CONSTRAINT unique_measurement UNIQUE (device_timestamp, device_eui);


--
-- Name: idx_lora_metadata_device_time; Type: INDEX; Schema: public; Owner: app_user
--

CREATE INDEX idx_lora_metadata_device_time ON public.lora_uplink_metadata USING btree (device_eui, received_at);


--
-- Name: idx_lora_metadata_received_at; Type: INDEX; Schema: public; Owner: app_user
--

CREATE INDEX idx_lora_metadata_received_at ON public.lora_uplink_metadata USING btree (received_at);


--
-- Name: idx_lora_metadata_sf; Type: INDEX; Schema: public; Owner: app_user
--

CREATE INDEX idx_lora_metadata_sf ON public.lora_uplink_metadata USING btree (spreading_factor);


--
-- Name: idx_sensor_data_device_eui_timestamp; Type: INDEX; Schema: public; Owner: app_user
--

CREATE INDEX idx_sensor_data_device_eui_timestamp ON public.sensor_data USING btree (device_eui, device_timestamp);


--
-- Name: idx_sensor_data_device_timestamp; Type: INDEX; Schema: public; Owner: app_user
--

CREATE INDEX idx_sensor_data_device_timestamp ON public.sensor_data USING btree (device_timestamp);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: app_user
--

GRANT USAGE ON SCHEMA public TO grafana_viewer;


--
-- Name: TABLE sensor_data; Type: ACL; Schema: public; Owner: app_user
--

GRANT SELECT ON TABLE public.sensor_data TO grafana_viewer;


--
-- PostgreSQL database dump complete
--

\unrestrict QyfNp1MqieiiTGlIAldoT0YzH7o88dYztmtDVVH7nfmIK9xa9P7I7Wnew0eec0r

