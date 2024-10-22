import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./einnsyn.base.tsp";

using Http;
using OpenAPI;
using eInnsyn;

namespace eInnsyn.noark;

/* Properties shared by all Noark objects */
model NoarkBase extends EInnsynBase {
  /**
   * The unique identifier for the resource, given by the user's system.
   */
  systemId: string;

  /**
   * The administrative unit that is responsible for the resource. This
   * is by default derived from the credentials used to authenticate the
   * request on creation, or it can manually be set to an Enhet owned by
   * that derived Enhet.
   */
  journalenhet: EInnsynId | Enhet;
}

/* Arkiv */
@extension("x-resourceId", "Arkiv")
@extension("x-idPrefix", "ark")
model Arkiv extends NoarkBase {
  @visibility("read") entity?: "Arkiv";
  tittel: string;
  parent?: EInnsynId | Arkiv;
}

@route("/arkiv")
@tag("Arkiv")
interface ArkivRoutes extends GloballyRoutable<Arkiv, "Arkiv"> {
  @route("/{arkivId}/arkivdel")
  @get
  @operationId("GetArkivArkivdelList")
  getArkivdelList(
    ...ListParameters,
    @path arkivId: EInnsynId,
  ): ResponseList<Arkivdel>;

  @route("/{arkivId}/arkivdel")
  @post
  @operationId("PostArkivArkivdel")
  addArkivdel(@path arkivId: EInnsynId, @body arkivdel: Arkivdel): Arkivdel;

  @route("/{arkivId}/arkiv")
  @get
  @operationId("GetArkivArkivList")
  getArkivList(
    ...ListParameters,
    @path arkivId: EInnsynId,
  ): ResponseList<Arkiv>;

  @route("/{arkivId}/arkiv")
  @post
  @operationId("PostArkivArkiv")
  addArkiv(@path arkivId: EInnsynId, @body arkiv: Arkiv): Arkiv;

  @route("/{arkivId}/saksmappe")
  @get
  @operationId("GetArkivSaksmappeList")
  getSaksmappeList(
    ...ListParameters,
    @path arkivId: EInnsynId,
  ): ResponseList<Saksmappe>;

  @route("/{arkivId}/saksmappe")
  @post
  @operationId("PostArkivSaksmappe")
  addSaksmappe(@path arkivId: EInnsynId, @body saksmappe: Saksmappe): Saksmappe;

  @route("/{arkivId}/moetemappe")
  @get
  @operationId("GetArkivMoetemappeList")
  getMoetemappeList(
    ...ListParameters,
    @path arkivId: EInnsynId,
  ): ResponseList<Moetemappe>;

  @route("/{arkivId}/moetemappe")
  @post
  @operationId("PostArkivMoetemappe")
  addMoetemappe(
    @path arkivId: EInnsynId,
    @body moetemappe: Moetemappe,
  ): Moetemappe;
}

/* Arkivdel */
@extension("x-resourceId", "Arkivdel")
@extension("x-idPrefix", "arkd")
model Arkivdel extends NoarkBase {
  @visibility("read") entity?: "Arkivdel";
  tittel: string;
  parent?: EInnsynId | Arkiv;
}

@route("/arkivdel")
@tag("Arkivdel")
interface ArkivdelRoutes extends Routable<Arkivdel, "Arkivdel"> {
  @route("/{id}/klasse")
  @get
  @operationId("GetArkivdelKlasseList")
  getKlasseList(...ListParameters, @path id: EInnsynId): ResponseList<Klasse>;

  @route("/{id}/klasse")
  @post
  @operationId("PostArkivdelKlasse")
  addKlasse(@path id: EInnsynId, @body klasse: Klasse): Klasse;

  @route("/{id}/klassifikasjonssystem")
  @get
  @operationId("GetArkivdelKlassifikasjonssystemList")
  getKlassifikasjonssystemList(
    ...ListParameters,
    @path id: EInnsynId,
  ): ResponseList<Klassifikasjonssystem>;

  @route("/{id}/klassifikasjonssystem")
  @post
  @operationId("PostArkivdelKlassifikasjonssystem")
  addKlassifikasjonssystem(
    @path id: EInnsynId,
    @body klassifikasjonssystem: Klassifikasjonssystem,
  ): Klassifikasjonssystem;

  @route("/{id}/saksmappe")
  @get
  @operationId("GetArkivdelSaksmappeList")
  getSaksmappeList(
    ...ListParameters,
    @path id: EInnsynId,
  ): ResponseList<Saksmappe>;

  @route("/{id}/saksmappe")
  @post
  @operationId("PostArkivdelSaksmappe")
  addSaksmappe(@path id: EInnsynId, @body saksmappe: Saksmappe): Saksmappe;

  @route("/{id}/moetemappe")
  @get
  @operationId("GetArkivdelMoetemappeList")
  getMoetemappeList(
    ...ListParameters,
    @path id: EInnsynId,
  ): ResponseList<Moetemappe>;

  @route("/{id}/moetemappe")
  @post
  @operationId("PostArkivdelMoetemappe")
  addMoetemappe(@path id: EInnsynId, @body moetemappe: Moetemappe): Moetemappe;
}

/* Klassifikasjonssystem */
@extension("x-resourceId", "Klassifikasjonssystem")
@extension("x-idPrefix", "ksys")
model Klassifikasjonssystem extends NoarkBase {
  @visibility("read") entity?: "Klassifikasjonssystem";
  tittel: string;
  parent?: EInnsynId | Arkivdel;
}

@route("/klassifikasjonssystem")
@tag("Klassifikasjonssystem")
interface KlassifikasjonssystemRoutes
  extends Routable<Klassifikasjonssystem, "Klassifikasjonssystem"> {
  @route("/{klassifikasjonssystemId}/klasse")
  @get
  @operationId("GetKlassifikasjonssystemKlasseList")
  getKlasseList(
    ...ListParameters,
    @path klassifikasjonssystemId: EInnsynId,
  ): ResponseList<Klasse>;

  @route("/{klassifikasjonssystemId}/klasse")
  @post
  @operationId("PostKlassifikasjonssystemKlasse")
  addKlasse(
    @path klassifikasjonssystemId: EInnsynId,
    @body klasse: Klasse,
  ): Klasse;
}

/* Klasse */
@extension("x-resourceId", "Klasse")
@extension("x-idPrefix", "kla")
model Klasse extends NoarkBase {
  @visibility("read") entity?: "Klasse";
  tittel: string;
  parent?: EInnsynId | Arkivdel | Klasse | Klassifikasjonssystem;
}

@route("/klasse")
@tag("Klasse")
interface KlasseRoutes extends Routable<Klasse, "Klasse"> {
  @route("/{klasseId}/saksmappe")
  @get
  @operationId("GetKlasseSaksmappeList")
  getSaksmappeList(
    ...ListParameters,
    @path klasseId: EInnsynId,
  ): ResponseList<Saksmappe>;

  @route("/{klasseId}/saksmappe")
  @post
  @operationId("PostKlasseSaksmappe")
  addSaksmappe(
    @path klasseId: EInnsynId,
    @body saksmappe: Saksmappe,
  ): Saksmappe;

  @route("/{klasseId}/moetemappe")
  @get
  @operationId("GetKlasseMoetemappeList")
  getMoetemappeList(
    ...ListParameters,
    @path klasseId: EInnsynId,
  ): ResponseList<Moetemappe>;

  @route("/{klasseId}/moetemappe")
  @post
  @operationId("PostKlasseMoetemappe")
  addMoetemappe(
    @path klasseId: EInnsynId,
    @body moetemappe: Moetemappe,
  ): Moetemappe;
}

/* Mappe */
@extension("x-resourceId", "Mappe")
model Mappe extends NoarkBase {
  offentligTittel: string;
  offentligTittelSensitiv: string;
  beskrivelse?: string;
  noekkelord?: string;
  @visibility("read") publisertDato: plainDate;
  @visibility("read") parent:
    | Saksmappe
    | Moetemappe
    | Arkiv
    | Arkivdel
    | Klasse;
}

@route("/mappe")
@tag("Mappe")
interface MappeRoutes extends Routable<Mappe, "Mappe"> {}

/* Saksmappe */
@extension("x-resourceId", "Saksmappe")
@extension("x-idPrefix", "sm")
model Saksmappe extends Mappe {
  @visibility("read") entity?: "Saksmappe";
  @minValue(1900) saksaar: integer;
  @minValue(0) sakssekvensnummer: integer;
  saksnummer?: string;
  saksdato?: plainDate;
  journalpost: (EInnsynId | Journalpost)[];
  administrativEnhet: string;
  @visibility("read") administrativEnhetObjekt: EInnsynId | Enhet;
}

@route("/saksmappe")
@tag("Saksmappe")
interface SaksmappeRoutes extends Routable<Saksmappe, "Saksmappe"> {
  @route("/{id}/journalpost")
  @get
  @operationId("GetSaksmappeJournalpostList")
  getJournalpostList(
    ...ListParameters,
    @path id: EInnsynId,
  ): ResponseList<Journalpost>;

  @route("/{id}/journalpost")
  @post
  @operationId("PostSaksmappeJournalpost")
  addJournalpost(
    @path id: EInnsynId,
    @body journalpost: Journalpost,
  ): Journalpost;
}

/* Moetemappe */
@extension("x-resourceId", "Moetemappe")
@extension("x-idPrefix", "mm")
model Moetemappe extends Mappe {
  @visibility("read") entity?: "Moetemappe";
  moetenummer: string;
  utvalg: string;
  @visibility("read") utvalgObjekt: EInnsynId | Enhet;
  moetedato: utcDateTime;
  moetested?: string;
  @maxLength(5000) videoLink?: string;
  referanseForrigeMoete?: EInnsynId | Moetemappe;
  referanseNesteMoete?: EInnsynId | Moetemappe;
  moetedokument?: (EInnsynId | Moetedokument)[];
  moetesak?: (EInnsynId | Moetesak)[];
}

@route("/moetemappe")
@tag("Moetemappe")
interface MoetemappeRoutes extends Routable<Moetemappe, "Moetemappe"> {
  @route("/{id}/moetesak")
  @get
  @operationId("GetMoetemappeMoetesakList")
  getMoetesakList(
    ...ListParameters,
    @path id: EInnsynId,
  ): ResponseList<Moetesak>;

  @route("/{id}/moetesak")
  @post
  @operationId("PostMoetemappeMoetesak")
  addMoetesak(@path id: EInnsynId, @body moetesak: Moetesak): Moetesak;

  @route("/{id}/moetedokument")
  @get
  @operationId("GetMoetemappeMoetedokumentList")
  getMoetedokumentList(
    ...ListParameters,
    @path id: EInnsynId,
  ): ResponseList<Moetedokument>;

  @route("/{id}/moetedokument")
  @post
  @operationId("PostMoetemappeMoetedokument")
  addMoetedokument(
    @path id: EInnsynId,
    @body moetedokument: Moetedokument,
  ): Moetedokument;
}

/* Registrering */
@extension("x-resourceId", "Registrering")
model Registrering extends NoarkBase {
  offentligTittel: string;
  offentligTittelSensitiv: string;
  beskrivelse?: string;

  /**
   * The date the resource was published. This field is updated automatically, but can be set manually by admins.
   */
  @visibility("read") publisertDato: utcDateTime;

  /**
   * The date the resource was last updated. This field is updated automatically, but can be set manually by admins.
   */
  @visibility("read") oppdatertDato: utcDateTime;

  korrespondansepart?: (EInnsynId | Korrespondansepart)[];
  dokumentbeskrivelse?: (EInnsynId | Dokumentbeskrivelse)[];
}

/* Journalpost */
@extension("x-resourceId", "Journalpost")
@extension("x-idPrefix", "jp")
model Journalpost extends Registrering {
  @visibility("read") entity?: "Journalpost";
  @minValue(1900) journalaar: integer;
  @minValue(0) journalsekvensnummer: integer;
  @minValue(0) journalpostnummer: integer;
  journalposttype: string;
  journaldato: plainDate;
  dokumentetsDato?: plainDate;
  skjerming?: EInnsynId | Saksmappe;
  @visibility("read") administrativEnhet: string;
  @visibility("read") administrativEnhetObjekt: EInnsynId | Enhet;
  @visibility("read") sorteringstype: string;
  @visibility("read") saksmappe: EInnsynId | Saksmappe;
}

@route("/journalpost")
@tag("Journalpost")
interface JournalpostRoutes extends Routable<Journalpost, "Journalpost"> {
  @route("/{journalpostId}/korrespondansepart")
  @get
  @operationId("GetJournalpostKorrespondansepartList")
  getKorrespondansepartList(
    ...ListParameters,
    @path journalpostId: EInnsynId,
  ): ResponseList<Korrespondansepart>;

  @route("/{journalpostId}/korrespondansepart")
  @post
  @operationId("PostJournalpostKorrespondansepart")
  addKorrespondansepart(
    @path journalpostId: EInnsynId,
    @body korrespondansepart: Korrespondansepart,
  ): Korrespondansepart;

  @route("/{journalpostId}/dokumentbeskrivelse")
  @get
  @operationId("GetJournalpostDokumentbeskrivelseList")
  getDokumentbeskrivelseList(
    ...ListParameters,
    @path journalpostId: EInnsynId,
  ): ResponseList<Dokumentbeskrivelse>;

  @route("/{journalpostId}/dokumentbeskrivelse")
  @post
  @operationId("PostJournalpostDokumentbeskrivelse")
  addDokumentbeskrivelse(
    @path journalpostId: EInnsynId,
    @body dokumentbeskrivelse: Dokumentbeskrivelse,
  ): Dokumentbeskrivelse;

  @route("/{journalpostId}/dokumentbeskrivelse/{dokumentbeskrivelseId}")
  @delete
  @operationId("DeleteJournalpostDokumentbeskrivelse")
  deleteDokumentbeskrivelse(
    @path journalpostId: EInnsynId,
    @path dokumentbeskrivelseId: EInnsynId,
  ): Dokumentbeskrivelse;
}

/* Korrespondansepart */
@extension("x-resourceId", "Korrespondansepart")
@extension("x-idPrefix", "kp")
model Korrespondansepart extends NoarkBase {
  @visibility("read") entity?: "Korrespondansepart";
  korrespondansepartNavn: string;
  korrespondansepartNavnSensitiv: string;
  korrespondanseparttype: string;
  saksbehandler?: string;
  epostadresse?: string;
  @minValue(1000) @maxValue(9999) postnummer?: integer;
  erBehandlingsansvarlig?: boolean;
  administrativEnhet?: string;
  @visibility("read") parent: Journalpost | Moetedokument | Moetesak;
}

@route("/korrespondansepart")
@tag("Korrespondansepart")
interface KorrespondansepartRoutes
  extends Routable<Korrespondansepart, "Korrespondansepart"> {}

/* Skjerming */
@extension("x-resourceId", "Skjerming")
@extension("x-idPrefix", "skj")
model Skjerming extends NoarkBase {
  @visibility("read") entity?: "Skjerming";
  tilgangsrestriksjon: string;
  skjermingshjemmel?: string;
}

@route("/skjerming")
@tag("Skjerming")
interface SkjermingRoutes extends GloballyRoutable<Skjerming, "Skjerming"> {}

/* Moetesak */
@extension("x-resourceId", "Moetesak")
@extension("x-idPrefix", "ms")
model Moetesak extends Registrering {
  @visibility("read") entity?: "Moetesak";
  moetesakstype: string;
  @minValue(1900) moetesaksaar: integer;
  @minValue(0) moetesakssekvensnummer: integer;
  utvalg?: string;
  @visibility("read") utvalgObjekt: EInnsynId | Enhet;
  videoLink?: string;
  utredning?: EInnsynId | Utredning;
  innstilling?: EInnsynId | Moetesaksbeskrivelse;
  vedtak?: EInnsynId | Vedtak;
  moetemappe?: EInnsynId | Moetemappe;
}

@route("/moetesak")
@tag("Moetesak")
interface MoetesakRoutes extends Routable<Moetesak, "Moetesak"> {
  @route("/{moetesakId}/dokumentbeskrivelse")
  @get
  @operationId("GetMoetesakDokumentbeskrivelseList")
  getDokumentbeskrivelseList(
    ...ListParameters,
    @path moetesakId: EInnsynId,
  ): ResponseList<Dokumentbeskrivelse>;

  @route("/{moetesakId}/dokumentbeskrivelse")
  @post
  @operationId("PostMoetesakDokumentbeskrivelse")
  addDokumentbeskrivelse(
    @path moetesakId: EInnsynId,
    @body dokumentbeskrivelse: Dokumentbeskrivelse,
  ): Dokumentbeskrivelse;

  // @route("/{moetesakId}/utredning")
  // @get
  // @operationId("GetMoetesakUtredning")
  // getUtredning(@path moetesakId: EInnsynId): ResponseGet<Utredning>;

  // @route("/{moetesakId}/utredning")
  // @post
  // @operationId("PostMoetesakUtredning")
  // addUtredning(
  //   @path moetesakId: EInnsynId,
  //   @body utredning: Utredning,
  // ): Utredning;

  // @route("/{moetesakId}/vedtak")
  // @get
  // @operationId("GetMoetesakVedtak")
  // getVedtak(@path moetesakId: EInnsynId): ResponseGet<Vedtak>;

  // @route("/{moetesakId}/vedtak")
  // @post
  // @operationId("PostMoetesakVedtak")
  // addVedtak(@path moetesakId: EInnsynId, @body vedtak: Vedtak): Vedtak;
}

/* Utredning */
@extension("x-resourceId", "Utredning")
@extension("x-idPrefix", "utr")
model Utredning extends NoarkBase {
  @visibility("read") entity?: "Utredning";
  saksbeskrivelse: EInnsynId | Moetesaksbeskrivelse;
  innstilling: EInnsynId | Moetesaksbeskrivelse;
  utredningsdokument?: (EInnsynId | Dokumentbeskrivelse)[];
}

@route("/utredning")
@tag("Utredning")
interface UtredningRoutes extends Routable<Utredning, "Utredning"> {
  @route("/{utredningId}/utredningsdokument")
  @get
  @operationId("GetUtredningUtredningsdokumentList")
  getDokumentbeskrivelseList(
    ...ListParameters,
    @path utredningId: EInnsynId,
  ): ResponseList<Dokumentbeskrivelse>;

  @route("/{utredningId}/utredningsdokument")
  @post
  @operationId("PostUtredningUtredningsdokument")
  addDokumentbeskrivelse(
    @path utredningId: EInnsynId,
    @body dokumentbeskrivelse: Dokumentbeskrivelse,
  ): Dokumentbeskrivelse;

  @route("/{utredningId}/utredningsdokument/{utredningsdokumentId}")
  @delete
  @operationId("DeleteUtredningUtredningsdokument")
  deleteDokumentbeskrivelse(
    @path utredningId: EInnsynId,
    @path utredningsdokumentId: EInnsynId,
  ): Dokumentbeskrivelse;
}

/* Vedtak */
@extension("x-resourceId", "Vedtak")
@extension("x-idPrefix", "ved")
model Vedtak extends NoarkBase {
  @visibility("read") entity?: "Vedtak";
  vedtakstekst: EInnsynId | Moetesaksbeskrivelse;
  votering?: (EInnsynId | Votering)[];
  behandlingsprotokoll?: EInnsynId | Behandlingsprotokoll;
  vedtaksdokument?: (EInnsynId | Dokumentbeskrivelse)[];
  dato: plainDate;
}

@route("/vedtak")
@tag("Vedtak")
interface VedtakRoutes extends Routable<Vedtak, "Vedtak"> {
  // @route("/{vedtakId}/votering")
  // @get
  // @operationId("GetVedtakVoteringList")
  // getVoteringList(
  //   ...ListParameters,
  //   @path vedtakId: EInnsynId,
  // ): ResponseList<Votering>;

  // @route("/{vedtakId}/votering")
  // @post
  // @operationId("PostVedtakVotering")
  // addVotering(@path vedtakId: EInnsynId, @body votering: Votering): Votering;

  @route("/{vedtakId}/vedtaksdokument")
  @get
  @operationId("GetVedtakVedtaksdokumentList")
  getDokumentbeskrivelseList(
    ...ListParameters,
    @path vedtakId: EInnsynId,
  ): ResponseList<Dokumentbeskrivelse>;

  @route("/{vedtakId}/vedtaksdokument")
  @post
  @operationId("PostVedtakVedtaksdokument")
  addDokumentbeskrivelse(
    @path vedtakId: EInnsynId,
    @body dokumentbeskrivelse: Dokumentbeskrivelse,
  ): Dokumentbeskrivelse;

  @route("/{vedtakId}/vedtaksdokument/{vedtaksdokumentId}")
  @delete
  @operationId("DeleteVedtakVedtaksdokument")
  deleteDokumentbeskrivelse(
    @path vedtakId: EInnsynId,
    @path vedtaksdokumentId: EInnsynId,
  ): Dokumentbeskrivelse;
}

/* Votering */
@extension("x-resourceId", "Votering")
@extension("x-idPrefix", "vot")
model Votering extends NoarkBase {
  @visibility("read") entity?: "Votering";
  moetedeltaker: EInnsynId | Moetedeltaker;
  stemme: "Ja" | "Nei" | "Blankt";
  representerer?: EInnsynId | Identifikator;
}

@route("/votering")
@tag("Votering")
interface VoteringRoutes extends Routable<Votering, "Votering"> {}

/* Moetesaksbeskrivelse */
@extension("x-resourceId", "Moetesaksbeskrivelse")
@extension("x-idPrefix", "msb")
model Moetesaksbeskrivelse extends NoarkBase {
  @visibility("read") entity?: "Moetesaksbeskrivelse";
  tekstInnhold: string;
  tekstFormat: string;
}

@route("/moetesaksbeskrivelse")
@tag("Moetesaksbeskrivelse")
interface MoetesaksbeskrivelseRoutes
  extends Routable<Moetesaksbeskrivelse, "Moetesaksbeskrivelse"> {}

/* Behandlingsprotokoll */
@extension("x-resourceId", "Behandlingsprotokoll")
@extension("x-idPrefix", "bp")
model Behandlingsprotokoll extends NoarkBase {
  @visibility("read") entity?: "Behandlingsprotokoll";
  tekstInnhold: string;
  tekstFormat: string;
}

@route("/behandlingsprotokoll")
@tag("Behandlingsprotokoll")
interface BehandlingsprotokollRoutes
  extends Routable<Behandlingsprotokoll, "Behandlingsprotokoll"> {}

/* Moetedeltaker */
@extension("x-resourceId", "Moetedeltaker")
@extension("x-idPrefix", "md")
model Moetedeltaker extends NoarkBase {
  @visibility("read") entity?: "Moetedeltaker";
  moetedeltakerNavn: string;
  moetedeltakerFunksjon?: string;
}

@route("/moetedeltaker")
@tag("Moetedeltaker")
interface MoetedeltakerRoutes
  extends Routable<Moetedeltaker, "Moetedeltaker"> {}

/**
 * Identifikator
 */
@extension("x-resourceId", "Identifikator")
@extension("x-idPrefix", "ide")
model Identifikator extends NoarkBase {
  @visibility("read") entity?: "Identifikator";
  navn: string;
  identifikator: string;
  initialer: string;
  epostadresse: string;
}

@route("/identifikator")
@tag("Identifikator")
interface IdentifikatorRoutes
  extends Routable<Identifikator, "Identifikator"> {}

/**
 * Dokumentbeskrivelse
 */
@extension("x-resourceId", "Dokumentbeskrivelse")
@extension("x-idPrefix", "db")
model Dokumentbeskrivelse extends NoarkBase {
  @visibility("read") entity?: "Dokumentbeskrivelse";
  tittel: string;
  tittelSensitiv: string;
  dokumentnummer: integer;
  dokumenttype?: string;
  tilknyttetRegistreringSom: string;
  dokumentobjekt?: (EInnsynId | Dokumentobjekt)[];
}

@route("/dokumentbeskrivelse")
@tag("Dokumentbeskrivelse")
interface DokumentbeskrivelseRoutes
  extends Routable<Dokumentbeskrivelse, "Dokumentbeskrivelse"> {
  @route("/dokumentbeskrivelse/{dokumentbeskrivelseId}/download/{subId}.{docExtension}")
  @get
  @operationId("DownloadDokumentbeskrivelse")
  downloadDokumentbeskrivelse(
    @path dokumentbeskrivelseId: EInnsynId,
    @path subId: string,
    @path docExtension: string,
  ): Response<200>;
}

@extension("x-resourceId", "Dokumentobjekt")
@extension("x-idPrefix", "do")
model Dokumentobjekt extends NoarkBase {
  @visibility("read") entity?: "Dokumentobjekt";
  @format("url") referanseDokumentfil: string;
  format?: string;
  sjekksum?: string;
  sjekksumAlgoritme?: string;
  dokumentbeskrivelse?: EInnsynId | Dokumentbeskrivelse;
}

@route("/dokumentobjekt")
@tag("Dokumentobjekt")
interface DokumentobjektRoutes
  extends Routable<Dokumentobjekt, "Dokumentobjekt"> {}

@extension("x-resourceId", "Moetedokument")
@extension("x-idPrefix", "mdok")
model Moetedokument extends Registrering {
  @visibility("read") entity?: "Moetedokument";
  moetedokumenttype: string;
  saksbehandler?: string;
  saksbehandlerSensitiv?: string;
  moetemappe?: EInnsynId | Moetemappe;
}

@route("/moetedokument")
@tag("Moetedokument")
interface MoetedokumentRoutes extends Routable<Moetedokument, "Moetedokument"> {
  @route("/{moetedokumentId}/dokumentbeskrivelse")
  @get
  @operationId("GetMoetedokumentDokumentbeskrivelseList")
  getDokumentbeskrivelseList(
    ...ListParameters,
    @path moetedokumentId: EInnsynId,
  ): ResponseList<Dokumentbeskrivelse>;

  @route("/{moetedokumentId}/dokumentbeskrivelse")
  @post
  @operationId("PostMoetedokumentDokumentbeskrivelse")
  addDokumentbeskrivelse(
    @path moetedokumentId: EInnsynId,
    @body dokumentbeskrivelse: Dokumentbeskrivelse,
  ): Dokumentbeskrivelse;
}
