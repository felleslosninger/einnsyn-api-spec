import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./einnsyn.base.tsp";

using Http;
using OpenAPI;
using EInnsyn;

namespace EInnsyn;

namespace ArkivBase {
  /* Properties shared by all Noark objects */
  model ArkivBase extends Base.Base {
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
    journalenhet: ExpandableField<Enhet.Enhet>;
  }
}

namespace Arkiv {
  /**
   * Represents a top-level archive in the Noark structure.
   */
  @extension("x-idPrefix", "ark")
  model Arkiv extends ArkivBase.ArkivBase {
    /**
     * Entity type.
     */
    @visibility("read") entity?: "Arkiv";

    /**
     * The title of the archive.
     */
    tittel: string;

    /**
     * The parent archive to which this archive belongs.
     */
    parent?: ExpandableField<Arkiv>;
  }

  model ListByArkivParameters extends QueryParameters.ListParameters {
    @path arkivId: eInnsynId<Arkiv>;
  }

  @route("/arkiv")
  @tag("Arkiv")
  interface ArkivRoutes extends GloballyRoutable<Arkiv> {
    @route("/{arkivId}/arkivdel")
    @get
    listArkivdel(
      ...ListByArkivParameters,
    ): Responses.ListResponse<Arkivdel.Arkivdel>;

    @route("/{arkivId}/arkivdel")
    @post
    addArkivdel(
      @path arkivId: eInnsynId<Arkiv>,
      @body arkivdel: Arkivdel.Arkivdel,
    ): Responses.AddResponse<Arkivdel.Arkivdel>;

    @route("/{arkivId}/arkiv")
    @get
    listArkiv(...ListByArkivParameters): Responses.ListResponse<Arkiv>;

    @route("/{arkivId}/arkiv")
    @post
    addArkiv(
      @path arkivId: eInnsynId<Arkiv>,
      @body arkiv: Arkiv,
    ): Responses.AddResponse<Arkiv>;

    @route("/{arkivId}/saksmappe")
    @get
    listSaksmappe(
      ...ListByArkivParameters,
    ): Responses.ListResponse<Saksmappe.Saksmappe>;

    @route("/{arkivId}/saksmappe")
    @post
    addSaksmappe(
      @path arkivId: eInnsynId<Arkiv>,
      @body saksmappe: Saksmappe.Saksmappe,
    ): Responses.AddResponse<Saksmappe.Saksmappe>;

    @route("/{arkivId}/moetemappe")
    @get
    listMoetemappe(
      ...ListByArkivParameters,
    ): Responses.ListResponse<Moetemappe.Moetemappe>;

    @route("/{arkivId}/moetemappe")
    @post
    addMoetemappe(
      @path arkivId: eInnsynId<Arkiv>,
      @body moetemappe: Moetemappe.Moetemappe,
    ): Responses.AddResponse<Moetemappe.Moetemappe>;
  }
}

namespace Arkivdel {
  /* Arkivdel */
  @extension("x-idPrefix", "arkd")
  model Arkivdel extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Arkivdel";
    tittel: string;
    parent?: ExpandableField<Arkiv.Arkiv>;
  }

  model ListByArkivdelParameters extends QueryParameters.ListParameters {
    @path arkivdelId: eInnsynId<Arkivdel>;
  }

  @route("/arkivdel")
  @tag("Arkivdel")
  interface ArkivdelRoutes extends Routable<Arkivdel> {
    @route("/{arkivdelId}/klasse")
    @get
    listKlasse(
      ...ListByArkivdelParameters,
    ): Responses.ListResponse<Klasse.Klasse>;

    @route("/{arkivdelId}/klasse")
    @post
    addKlasse(
      @path arkivdelId: eInnsynId<Arkivdel>,
      @body klasse: Klasse.Klasse,
    ): Responses.AddResponse<Klasse.Klasse>;

    @route("/{arkivdelId}/klassifikasjonssystem")
    @get
    listKlassifikasjonssystem(
      ...ListByArkivdelParameters,
    ): Responses.ListResponse<Klassifikasjonssystem.Klassifikasjonssystem>;

    @route("/{arkivdelId}/klassifikasjonssystem")
    @post
    addKlassifikasjonssystem(
      @path arkivdelId: eInnsynId<Arkivdel>,
      @body klassifikasjonssystem: Klassifikasjonssystem.Klassifikasjonssystem,
    ): Responses.AddResponse<Klassifikasjonssystem.Klassifikasjonssystem>;

    @route("/{arkivdelId}/saksmappe")
    @get
    listSaksmappe(
      ...ListByArkivdelParameters,
    ): Responses.ListResponse<Saksmappe.Saksmappe>;

    @route("/{arkivdelId}/saksmappe")
    @post
    addSaksmappe(
      @path arkivdelId: eInnsynId<Arkivdel>,
      @body saksmappe: Saksmappe.Saksmappe,
    ): Responses.AddResponse<Saksmappe.Saksmappe>;

    @route("/{arkivdelId}/moetemappe")
    @get
    listMoetemappe(
      ...ListByArkivdelParameters,
    ): Responses.ListResponse<Moetemappe.Moetemappe>;

    @route("/{arkivdelId}/moetemappe")
    @post
    addMoetemappe(
      @path arkivdelId: eInnsynId<Arkivdel>,
      @body moetemappe: Moetemappe.Moetemappe,
    ): Responses.AddResponse<Moetemappe.Moetemappe>;
  }
}

namespace Klassifikasjonssystem {
  /* Klassifikasjonssystem */
  @extension("x-idPrefix", "ksys")
  model Klassifikasjonssystem extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Klassifikasjonssystem";
    tittel: string;
    parent?: ExpandableField<Arkivdel.Arkivdel>;
  }

  @route("/klassifikasjonssystem")
  @tag("Klassifikasjonssystem")
  interface KlassifikasjonssystemRoutes
    extends Routable<Klassifikasjonssystem> {
    @route("/{klassifikasjonssystemId}/klasse")
    @get
    listKlasse(
      ...QueryParameters.ListParameters,
      @path klassifikasjonssystemId: eInnsynId<Klassifikasjonssystem>,
    ): Responses.ListResponse<Klasse.Klasse>;

    @route("/{klassifikasjonssystemId}/klasse")
    @post
    addKlasse(
      @path klassifikasjonssystemId: eInnsynId<Klassifikasjonssystem>,
      @body klasse: Klasse.Klasse,
    ): Responses.AddResponse<Klasse.Klasse>;
  }
}

namespace Klasse {
  /* Klasse */
  @extension("x-idPrefix", "kla")
  model Klasse extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Klasse";
    tittel: string;
    parent?:
      | eInnsynId
      | Arkivdel.Arkivdel
      | Klasse
      | Klassifikasjonssystem.Klassifikasjonssystem;
  }

  @route("/klasse")
  @tag("Klasse")
  interface KlasseRoutes extends Routable<Klasse> {
    @route("/{klasseId}/saksmappe")
    @get
    listSaksmappe(
      ...QueryParameters.ListParameters,
      @path klasseId: eInnsynId<Klasse>,
    ): Responses.ListResponse<Saksmappe.Saksmappe>;

    @route("/{klasseId}/saksmappe")
    @post
    addSaksmappe(
      @path klasseId: eInnsynId<Klasse>,
      @body saksmappe: Saksmappe.Saksmappe,
    ): Responses.AddResponse<Saksmappe.Saksmappe>;

    @route("/{klasseId}/moetemappe")
    @get
    listMoetemappe(
      ...QueryParameters.ListParameters,
      @path klasseId: eInnsynId<Klasse>,
    ): Responses.ListResponse<Moetemappe.Moetemappe>;

    @route("/{klasseId}/moetemappe")
    @post
    addMoetemappe(
      @path klasseId: eInnsynId<Klasse>,
      @body moetemappe: Moetemappe.Moetemappe,
    ): Responses.AddResponse<Moetemappe.Moetemappe>;
  }
}

namespace Mappe {
  /* Mappe */
  model Mappe extends ArkivBase.ArkivBase {
    offentligTittel: string;
    offentligTittelSensitiv: string;
    beskrivelse?: string;
    noekkelord?: string;
    @visibility("read") publisertDato?: plainDate;
    @visibility("read") oppdatertDato?: plainDate;
    @visibility("read") parent?:
      | Saksmappe.Saksmappe
      | Moetemappe.Moetemappe
      | Arkiv.Arkiv
      | Arkivdel.Arkivdel
      | Klasse.Klasse;
  }
}

namespace Saksmappe {
  /* Saksmappe */
  @extension("x-idPrefix", "sm")
  model Saksmappe extends Mappe.Mappe {
    @visibility("read") entity?: "Saksmappe";
    @minValue(1900) saksaar: integer;
    @minValue(0) sakssekvensnummer: integer;
    saksnummer?: string;
    saksdato?: plainDate;
    journalpost: ExpandableField<Journalpost.Journalpost>[];
    administrativEnhet: string;
    @visibility("read") administrativEnhetObjekt: ExpandableField<Enhet.Enhet>;
  }

  @route("/saksmappe")
  @tag("Saksmappe")
  interface SaksmappeRoutes extends Routable<Saksmappe> {
    @route("/{saksmappeId}/journalpost")
    @get
    listJournalpost(
      ...QueryParameters.ListParameters,
      @path saksmappeId: eInnsynId<Saksmappe>,
    ): Responses.ListResponse<Journalpost.Journalpost>;

    @route("/{saksmappeId}/journalpost")
    @post
    addJournalpost(
      @path saksmappeId: eInnsynId<Saksmappe>,
      @body journalpost: Journalpost.Journalpost,
    ): Responses.AddResponse<Journalpost.Journalpost>;
  }
}

namespace Moetemappe {
  /* Moetemappe */
  @extension("x-idPrefix", "mm")
  model Moetemappe extends Mappe.Mappe {
    @visibility("read") entity?: "Moetemappe";
    moetenummer: string;
    utvalg: string;
    @visibility("read") utvalgObjekt: ExpandableField<Enhet.Enhet>;
    moetedato: utcDateTime;
    moetested?: string;
    @maxLength(5000) videoLink?: string;
    referanseForrigeMoete?: ExpandableField<Moetemappe>;
    referanseNesteMoete?: ExpandableField<Moetemappe>;
    moetedokument?: ExpandableField<Moetedokument.Moetedokument>[];
    moetesak?: ExpandableField<Moetesak.Moetesak>[];
  }

  @route("/moetemappe")
  @tag("Moetemappe")
  interface MoetemappeRoutes extends Routable<Moetemappe> {
    @route("/{moetemappeId}/moetesak")
    @get
    listMoetesak(
      ...QueryParameters.ListParameters,
      @path moetemappeId: eInnsynId<Moetemappe>,
    ): Responses.ListResponse<Moetesak.Moetesak>;

    @route("/{moetemappeId}/moetesak")
    @post
    addMoetesak(
      @path moetemappeId: eInnsynId<Moetemappe>,
      @body moetesak: Moetesak.Moetesak,
    ): Responses.AddResponse<Moetesak.Moetesak>;

    @route("/{moetemappeId}/moetedokument")
    @get
    listMoetedokument(
      ...QueryParameters.ListParameters,
      @path moetemappeId: eInnsynId<Moetemappe>,
    ): Responses.ListResponse<Moetedokument.Moetedokument>;

    @route("/{moetemappeId}/moetedokument")
    @post
    addMoetedokument(
      @path moetemappeId: eInnsynId<Moetemappe>,
      @body moetedokument: Moetedokument.Moetedokument,
    ): Responses.AddResponse<Moetedokument.Moetedokument>;
  }
}

namespace Registrering {
  /* Registrering */
  model Registrering extends ArkivBase.ArkivBase {
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

    korrespondansepart?: ExpandableField<Korrespondansepart.Korrespondansepart>[];
    dokumentbeskrivelse?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>[];
  }
}

namespace Journalpost {
  /* Journalpost */
  @extension("x-idPrefix", "jp")
  model Journalpost extends Registrering.Registrering {
    @visibility("read") entity?: "Journalpost";
    @minValue(1900) journalaar: integer;
    @minValue(0) journalsekvensnummer: integer;
    @minValue(0) journalpostnummer: integer;
    journalposttype:
      | "inngaaende_dokument"
      | "utgaaende_dokument"
      | "organinternt_dokument_uten_oppfoelging"
      | "organinternt_dokument_for_oppfoelging"
      | "saksframlegg"
      | "sakskart"
      | "moeteprotokoll"
      | "moetebok"
      | "ukjent";
    journaldato: plainDate;
    dokumentetsDato?: plainDate;
    skjerming?: ExpandableField<Saksmappe.Saksmappe>;
    legacyJournalposttype?: string;
    legacyFoelgsakenReferanse?: string[];
    @visibility("read") administrativEnhet: string;
    @visibility("read") administrativEnhetObjekt: ExpandableField<Enhet.Enhet>;
    @visibility("read") saksmappe: ExpandableField<Saksmappe.Saksmappe>;
  }

  @route("/journalpost")
  @tag("Journalpost")
  interface JournalpostRoutes extends Routable<Journalpost> {
    @route("/{journalpostId}/korrespondansepart")
    @get
    listKorrespondansepart(
      ...QueryParameters.ListParameters,
      @path journalpostId: eInnsynId<Journalpost>,
    ): Responses.ListResponse<Korrespondansepart.Korrespondansepart>;

    @route("/{journalpostId}/korrespondansepart")
    @post
    addKorrespondansepart(
      @path journalpostId: eInnsynId<Journalpost>,
      @body korrespondansepart: Korrespondansepart.Korrespondansepart,
    ): Responses.AddResponse<Korrespondansepart.Korrespondansepart>;

    @route("/{journalpostId}/dokumentbeskrivelse")
    @get
    listDokumentbeskrivelse(
      ...QueryParameters.ListParameters,
      @path journalpostId: eInnsynId<Journalpost>,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{journalpostId}/dokumentbeskrivelse")
    @post
    addDokumentbeskrivelse(
      @path journalpostId: eInnsynId<Journalpost>,
      @body dokumentbeskrivelse: Dokumentbeskrivelse.Dokumentbeskrivelse,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{journalpostId}/dokumentbeskrivelse/{dokumentbeskrivelseId}")
    @delete
    deleteDokumentbeskrivelse(
      @path journalpostId: eInnsynId<Journalpost>,

      @path
      dokumentbeskrivelseId: eInnsynId<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Korrespondansepart {
  /* Korrespondansepart */
  @extension("x-idPrefix", "kp")
  model Korrespondansepart extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Korrespondansepart";
    korrespondansepartNavn: string;
    korrespondansepartNavnSensitiv: string;
    korrespondanseparttype: string;
    saksbehandler?: string;
    epostadresse?: string;
    @minValue(1000) @maxValue(9999) postnummer?: integer;
    erBehandlingsansvarlig?: boolean;
    administrativEnhet?: string;

    @visibility("read")
    parent: Journalpost.Journalpost | Moetedokument.Moetedokument | Moetesak.Moetesak;
  }

  @route("/korrespondansepart")
  @tag("Korrespondansepart")
  interface KorrespondansepartRoutes extends Routable<Korrespondansepart> {}
}

namespace Skjerming {
  /* Skjerming */
  @extension("x-idPrefix", "skj")
  model Skjerming extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Skjerming";
    tilgangsrestriksjon: string;
    skjermingshjemmel?: string;
  }

  @route("/skjerming")
  @tag("Skjerming")
  interface SkjermingRoutes extends GloballyRoutable<Skjerming> {}
}

namespace Moetesak {
  /* Moetesak */
  @extension("x-idPrefix", "ms")
  model Moetesak extends Registrering.Registrering {
    @visibility("read") entity?: "Moetesak";
    moetesakstype:
      | "moete"
      | "politisk"
      | "delegert"
      | "interpellasjon"
      | "godkjenning"
      | "orientering"
      | "referat"
      | "annet";
    @minValue(1900) moetesaksaar: integer;
    @minValue(0) moetesakssekvensnummer: integer;
    utvalg?: string;
    @visibility("read") utvalgObjekt: ExpandableField<Enhet.Enhet>;
    videoLink?: string;
    utredning?: ExpandableField<Utredning.Utredning>;
    innstilling?: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;
    vedtak?: ExpandableField<Vedtak.Vedtak>;
    moetemappe?: ExpandableField<Moetemappe.Moetemappe>;
  }

  @route("/moetesak")
  @tag("Moetesak")
  interface MoetesakRoutes extends Routable<Moetesak> {
    @route("/{moetesakId}/dokumentbeskrivelse")
    @get
    listDokumentbeskrivelse(
      ...QueryParameters.ListParameters,
      @path moetesakId: eInnsynId<Moetesak>,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{moetesakId}/dokumentbeskrivelse")
    @post
    addDokumentbeskrivelse(
      @path moetesakId: eInnsynId<Moetesak>,
      @body dokumentbeskrivelse: Dokumentbeskrivelse.Dokumentbeskrivelse,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{moetesakId}/utredning")
    @get
    getUtredning(
      ...QueryParameters.ListParameters,
      @path moetesakId: eInnsynId<Moetesak>,
    ): Responses.OkResponse<Utredning.Utredning>;

    @route("/{moetesakId}/utredning")
    @post
    addUtredning(
      @path moetesakId: eInnsynId<Moetesak>,
      @body utredning: Utredning.Utredning,
    ): Responses.AddResponse<Utredning.Utredning>;

    @route("/{moetesakId}/vedtak")
    @get
    getVedtak(
      ...QueryParameters.ListParameters,
      @path moetesakId: eInnsynId<Moetesak>,
    ): Responses.OkResponse<Vedtak.Vedtak>;

    @route("/{moetesakId}/vedtak")
    @post
    addVedtak(
      @path moetesakId: eInnsynId<Moetesak>,
      @body vedtak: Vedtak.Vedtak,
    ): Responses.AddResponse<Vedtak.Vedtak>;
  }
}

namespace Utredning {
  /* Utredning */
  @extension("x-idPrefix", "utr")
  model Utredning extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Utredning";
    saksbeskrivelse: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;
    innstilling: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;
    utredningsdokument?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>[];
  }

  @route("/utredning")
  @tag("Utredning")
  interface UtredningRoutes extends Routable<Utredning> {
    @route("/{utredningId}/utredningsdokument")
    @get
    listDokumentbeskrivelse(
      ...QueryParameters.ListParameters,
      @path utredningId: eInnsynId<Utredning>,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{utredningId}/utredningsdokument")
    @post
    addDokumentbeskrivelse(
      @path utredningId: eInnsynId<Utredning>,
      @body dokumentbeskrivelse: Dokumentbeskrivelse.Dokumentbeskrivelse,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{utredningId}/utredningsdokument/{utredningsdokumentId}")
    @delete
    deleteDokumentbeskrivelse(
      @path utredningId: eInnsynId<Utredning>,

      @path
      utredningsdokumentId: eInnsynId<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Vedtak {
  /* Vedtak */
  @extension("x-idPrefix", "ved")
  model Vedtak extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Vedtak";
    vedtakstekst: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;
    votering?: ExpandableField<Votering.Votering>[];
    foo?: string[];
    behandlingsprotokoll?: ExpandableField<Behandlingsprotokoll.Behandlingsprotokoll>;
    vedtaksdokument?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>[];
    dato: plainDate;
  }

  @route("/vedtak")
  @tag("Vedtak")
  interface VedtakRoutes extends Routable<Vedtak> {
    @route("/{vedtakId}/votering")
    @get
    listVotering(
      ...QueryParameters.ListParameters,
      @path vedtakId: eInnsynId<Vedtak>,
    ): Responses.ListResponse<Votering.Votering>;

    @route("/{vedtakId}/votering")
    @post
    addVotering(
      @path vedtakId: eInnsynId<Vedtak>,
      @body votering: Votering.Votering,
    ): Responses.AddResponse<Votering.Votering>;

    @route("/{vedtakId}/vedtaksdokument")
    @get
    listDokumentbeskrivelse(
      @path vedtakId: eInnsynId<Vedtak>,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{vedtakId}/vedtaksdokument")
    @post
    addDokumentbeskrivelse(
      @path vedtakId: eInnsynId<Vedtak>,
      @body dokumentbeskrivelse: Dokumentbeskrivelse.Dokumentbeskrivelse,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{vedtakId}/vedtaksdokument/{vedtaksdokumentId}")
    @delete
    deleteDokumentbeskrivelse(
      @path vedtakId: eInnsynId<Vedtak>,

      @path
      vedtaksdokumentId: eInnsynId<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Votering {
  /* Votering */
  @extension("x-idPrefix", "vot")
  model Votering extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Votering";
    moetedeltaker: ExpandableField<Moetedeltaker.Moetedeltaker>;
    stemme: "Ja" | "Nei" | "Blankt";
    representerer?: ExpandableField<Identifikator.Identifikator>;
  }

  @route("/votering")
  @tag("Votering")
  interface VoteringRoutes extends Routable<Votering> {}
}

namespace Moetesaksbeskrivelse {
  /* Moetesaksbeskrivelse */
  @extension("x-idPrefix", "msb")
  model Moetesaksbeskrivelse extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Moetesaksbeskrivelse";
    tekstInnhold: string;
    tekstFormat: string;
  }

  @route("/moetesaksbeskrivelse")
  @tag("Moetesaksbeskrivelse")
  interface MoetesaksbeskrivelseRoutes extends Routable<Moetesaksbeskrivelse> {}
}

namespace Behandlingsprotokoll {
  /* Behandlingsprotokoll */
  @extension("x-idPrefix", "bp")
  model Behandlingsprotokoll extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Behandlingsprotokoll";
    tekstInnhold: string;
    tekstFormat: string;
  }

  @route("/behandlingsprotokoll")
  @tag("Behandlingsprotokoll")
  interface BehandlingsprotokollRoutes extends Routable<Behandlingsprotokoll> {}
}

namespace Moetedeltaker {
  /* Moetedeltaker */
  @extension("x-idPrefix", "md")
  model Moetedeltaker extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Moetedeltaker";
    moetedeltakerNavn: string;
    moetedeltakerFunksjon?: string;
  }

  @route("/moetedeltaker")
  @tag("Moetedeltaker")
  interface MoetedeltakerRoutes extends Routable<Moetedeltaker> {}
}

namespace Identifikator {
  /**
   * Identifikator
   */
  @extension("x-idPrefix", "ide")
  model Identifikator extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Identifikator";
    navn: string;
    identifikator: string;
    initialer: string;
    @format("email") epostadresse: string;
  }

  @route("/identifikator")
  @tag("Identifikator")
  interface IdentifikatorRoutes extends Routable<Identifikator> {}
}

namespace Dokumentbeskrivelse {
  /**
   * Dokumentbeskrivelse
   */
  @extension("x-idPrefix", "db")
  model Dokumentbeskrivelse extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Dokumentbeskrivelse";
    tittel: string;
    tittelSensitiv: string;
    dokumentnummer: integer;
    dokumenttype?: string;
    tilknyttetRegistreringSom: string;
    dokumentobjekt?: ExpandableField<Dokumentobjekt.Dokumentobjekt>[];
  }

  @route("/dokumentbeskrivelse")
  @tag("Dokumentbeskrivelse")
  interface DokumentbeskrivelseRoutes extends Routable<Dokumentbeskrivelse> {
    @route("/dokumentbeskrivelse/{dokumentbeskrivelseId}/download/{subId}.{docExtension}")
    @get
    downloadDokumentbeskrivelse(
      @path dokumentbeskrivelseId: eInnsynId,
      @path subId: string,
      @path docExtension: string,
    ): Response<200>;
  }
}

namespace Dokumentobjekt {
  @extension("x-idPrefix", "do")
  model Dokumentobjekt extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Dokumentobjekt";
    referanseDokumentfil: url;
    format?: string;
    sjekksum?: string;
    sjekksumAlgoritme?: string;
    dokumentbeskrivelse?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }

  @route("/dokumentobjekt")
  @tag("Dokumentobjekt")
  interface DokumentobjektRoutes extends Routable<Dokumentobjekt> {}
}

namespace Moetedokument {
  @extension("x-idPrefix", "mdok")
  model Moetedokument extends Registrering.Registrering {
    @visibility("read") entity?: "Moetedokument";
    moetedokumenttype: string;
    saksbehandler?: string;
    saksbehandlerSensitiv?: string;
    moetemappe?: ExpandableField<Moetemappe.Moetemappe>;
  }

  @route("/moetedokument")
  @tag("Moetedokument")
  interface MoetedokumentRoutes extends Routable<Moetedokument> {
    @route("/{moetedokumentId}/dokumentbeskrivelse")
    @get
    listDokumentbeskrivelse(
      ...QueryParameters.ListParameters,
      @path moetedokumentId: eInnsynId<Moetedokument>,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{moetedokumentId}/dokumentbeskrivelse")
    @post
    addDokumentbeskrivelse(
      @path moetedokumentId: eInnsynId<Moetedokument>,
      @body dokumentbeskrivelse: Dokumentbeskrivelse.Dokumentbeskrivelse,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}
