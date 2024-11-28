import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./einnsyn.Base.tsp";

using Http;
using OpenAPI;
using eInnsyn;

namespace eInnsyn;

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
    journalenhet: EInnsynId | Enhet.Enhet;
  }
}

namespace Arkiv {
  /* Arkiv */
  @extension("x-resourceId", "Arkiv")
  @extension("x-idPrefix", "ark")
  model Arkiv extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Arkiv";
    tittel: string;
    parent?: EInnsynId | Arkiv;
  }

  @route("/arkiv")
  @tag("Arkiv")
  interface ArkivRoutes extends GloballyRoutable<Arkiv, "Arkiv"> {
    @route("/{arkivId}/arkivdel")
    @get
    getArkivdelList(
      ...QueryParameters.ListParameters,
      @path arkivId: EInnsynId,
    ): Responses.ListResponse<Arkivdel.Arkivdel>;

    @route("/{arkivId}/arkivdel")
    @post
    addArkivdel(
      @path arkivId: EInnsynId,
      @body arkivdel: Arkivdel.Arkivdel,
    ): Responses.AddResponse<Arkivdel.Arkivdel>;

    @route("/{arkivId}/arkiv")
    @get
    getArkivList(
      ...QueryParameters.ListParameters,
      @path arkivId: EInnsynId,
    ): Responses.ListResponse<Arkiv>;

    @route("/{arkivId}/arkiv")
    @post
    addArkiv(
      @path arkivId: EInnsynId,
      @body arkiv: Arkiv,
    ): Responses.AddResponse<Arkiv>;

    @route("/{arkivId}/saksmappe")
    @get
    getSaksmappeList(
      ...QueryParameters.ListParameters,
      @path arkivId: EInnsynId,
    ): Responses.ListResponse<Saksmappe.Saksmappe>;

    @route("/{arkivId}/saksmappe")
    @post
    addSaksmappe(
      @path arkivId: EInnsynId,
      @body saksmappe: Saksmappe.Saksmappe,
    ): Responses.AddResponse<Saksmappe.Saksmappe>;

    @route("/{arkivId}/moetemappe")
    @get
    getMoetemappeList(
      ...QueryParameters.ListParameters,
      @path arkivId: EInnsynId,
    ): Responses.ListResponse<Moetemappe.Moetemappe>;

    @route("/{arkivId}/moetemappe")
    @post
    addMoetemappe(
      @path arkivId: EInnsynId,
      @body moetemappe: Moetemappe.Moetemappe,
    ): Responses.AddResponse<Moetemappe.Moetemappe>;
  }
}

namespace Arkivdel {
  /* Arkivdel */
  @extension("x-resourceId", "Arkivdel")
  @extension("x-idPrefix", "arkd")
  model Arkivdel extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Arkivdel";
    tittel: string;
    parent?: EInnsynId | Arkiv.Arkiv;
  }

  @route("/arkivdel")
  @tag("Arkivdel")
  interface ArkivdelRoutes extends Routable<Arkivdel, "Arkivdel"> {
    @route("/{id}/klasse")
    @get
    getKlasseList(
      ...QueryParameters.ListParameters,
      @path id: EInnsynId,
    ): Responses.ListResponse<Klasse.Klasse>;

    @route("/{id}/klasse")
    @post
    addKlasse(
      @path id: EInnsynId,
      @body klasse: Klasse.Klasse,
    ): Responses.AddResponse<Klasse.Klasse>;

    @route("/{id}/klassifikasjonssystem")
    @get
    getKlassifikasjonssystemList(
      ...QueryParameters.ListParameters,
      @path id: EInnsynId,
    ): Responses.ListResponse<Klassifikasjonssystem.Klassifikasjonssystem>;

    @route("/{id}/klassifikasjonssystem")
    @post
    addKlassifikasjonssystem(
      @path id: EInnsynId,
      @body klassifikasjonssystem: Klassifikasjonssystem.Klassifikasjonssystem,
    ): Responses.AddResponse<Klassifikasjonssystem.Klassifikasjonssystem>;

    @route("/{id}/saksmappe")
    @get
    getSaksmappeList(
      ...QueryParameters.ListParameters,
      @path id: EInnsynId,
    ): Responses.ListResponse<Saksmappe.Saksmappe>;

    @route("/{id}/saksmappe")
    @post
    addSaksmappe(
      @path id: EInnsynId,
      @body saksmappe: Saksmappe.Saksmappe,
    ): Responses.AddResponse<Saksmappe.Saksmappe>;

    @route("/{id}/moetemappe")
    @get
    getMoetemappeList(
      ...QueryParameters.ListParameters,
      @path id: EInnsynId,
    ): Responses.ListResponse<Moetemappe.Moetemappe>;

    @route("/{id}/moetemappe")
    @post
    addMoetemappe(
      @path id: EInnsynId,
      @body moetemappe: Moetemappe.Moetemappe,
    ): Responses.AddResponse<Moetemappe.Moetemappe>;
  }
}

namespace Klassifikasjonssystem {
  /* Klassifikasjonssystem */
  @extension("x-resourceId", "Klassifikasjonssystem")
  @extension("x-idPrefix", "ksys")
  model Klassifikasjonssystem extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Klassifikasjonssystem";
    tittel: string;
    parent?: EInnsynId | Arkivdel.Arkivdel;
  }

  @route("/klassifikasjonssystem")
  @tag("Klassifikasjonssystem")
  interface KlassifikasjonssystemRoutes
    extends Routable<Klassifikasjonssystem, "Klassifikasjonssystem"> {
    @route("/{klassifikasjonssystemId}/klasse")
    @get
    getKlasseList(
      ...QueryParameters.ListParameters,
      @path klassifikasjonssystemId: EInnsynId,
    ): Responses.ListResponse<Klasse.Klasse>;

    @route("/{klassifikasjonssystemId}/klasse")
    @post
    addKlasse(
      @path klassifikasjonssystemId: EInnsynId,
      @body klasse: Klasse.Klasse,
    ): Responses.AddResponse<Klasse.Klasse>;
  }
}

namespace Klasse {
  /* Klasse */
  @extension("x-resourceId", "Klasse")
  @extension("x-idPrefix", "kla")
  model Klasse extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Klasse";
    tittel: string;
    parent?:
      | EInnsynId
      | Arkivdel.Arkivdel
      | Klasse
      | Klassifikasjonssystem.Klassifikasjonssystem;
  }

  @route("/klasse")
  @tag("Klasse")
  interface KlasseRoutes extends Routable<Klasse, "Klasse"> {
    @route("/{klasseId}/saksmappe")
    @get
    getSaksmappeList(
      ...QueryParameters.ListParameters,
      @path klasseId: EInnsynId,
    ): Responses.ListResponse<Saksmappe.Saksmappe>;

    @route("/{klasseId}/saksmappe")
    @post
    addSaksmappe(
      @path klasseId: EInnsynId,
      @body saksmappe: Saksmappe.Saksmappe,
    ): Responses.AddResponse<Saksmappe.Saksmappe>;

    @route("/{klasseId}/moetemappe")
    @get
    getMoetemappeList(
      ...QueryParameters.ListParameters,
      @path klasseId: EInnsynId,
    ): Responses.ListResponse<Moetemappe.Moetemappe>;

    @route("/{klasseId}/moetemappe")
    @post
    addMoetemappe(
      @path klasseId: EInnsynId,
      @body moetemappe: Moetemappe.Moetemappe,
    ): Responses.AddResponse<Moetemappe.Moetemappe>;
  }
}

namespace Mappe {
  /* Mappe */
  @extension("x-resourceId", "Mappe")
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
  @extension("x-resourceId", "Saksmappe")
  @extension("x-idPrefix", "sm")
  model Saksmappe extends Mappe.Mappe {
    @visibility("read") entity?: "Saksmappe";
    @minValue(1900) saksaar: integer;
    @minValue(0) sakssekvensnummer: integer;
    saksnummer?: string;
    saksdato?: plainDate;
    journalpost: (EInnsynId | Journalpost.Journalpost)[];
    administrativEnhet: string;
    @visibility("read") administrativEnhetObjekt: EInnsynId | Enhet.Enhet;
  }

  @route("/saksmappe")
  @tag("Saksmappe")
  interface SaksmappeRoutes extends Routable<Saksmappe, "Saksmappe"> {
    @route("/{id}/journalpost")
    @get
    getJournalpostList(
      ...QueryParameters.ListParameters,
      @path id: EInnsynId,
    ): Responses.ListResponse<Journalpost.Journalpost>;

    @route("/{id}/journalpost")
    @post
    addJournalpost(
      @path id: EInnsynId,
      @body journalpost: Journalpost.Journalpost,
    ): Responses.AddResponse<Journalpost.Journalpost>;
  }
}

namespace Moetemappe {
  /* Moetemappe */
  @extension("x-resourceId", "Moetemappe")
  @extension("x-idPrefix", "mm")
  model Moetemappe extends Mappe.Mappe {
    @visibility("read") entity?: "Moetemappe";
    moetenummer: string;
    utvalg: string;
    @visibility("read") utvalgObjekt: EInnsynId | Enhet.Enhet;
    moetedato: utcDateTime;
    moetested?: string;
    @maxLength(5000) videoLink?: string;
    referanseForrigeMoete?: EInnsynId | Moetemappe;
    referanseNesteMoete?: EInnsynId | Moetemappe;
    moetedokument?: (EInnsynId | Moetedokument.Moetedokument)[];
    moetesak?: (EInnsynId | Moetesak.Moetesak)[];
  }

  @route("/moetemappe")
  @tag("Moetemappe")
  interface MoetemappeRoutes extends Routable<Moetemappe, "Moetemappe"> {
    @route("/{id}/moetesak")
    @get
    getMoetesakList(
      ...QueryParameters.ListParameters,
      @path id: EInnsynId,
    ): Responses.ListResponse<Moetesak.Moetesak>;

    @route("/{id}/moetesak")
    @post
    addMoetesak(
      @path id: EInnsynId,
      @body moetesak: Moetesak.Moetesak,
    ): Responses.AddResponse<Moetesak.Moetesak>;

    @route("/{id}/moetedokument")
    @get
    getMoetedokumentList(
      ...QueryParameters.ListParameters,
      @path id: EInnsynId,
    ): Responses.ListResponse<Moetedokument.Moetedokument>;

    @route("/{id}/moetedokument")
    @post
    addMoetedokument(
      @path id: EInnsynId,
      @body moetedokument: Moetedokument.Moetedokument,
    ): Responses.AddResponse<Moetedokument.Moetedokument>;
  }
}

namespace Registrering {
  /* Registrering */
  @extension("x-resourceId", "Registrering")
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

    korrespondansepart?: (EInnsynId | Korrespondansepart.Korrespondansepart)[];
    dokumentbeskrivelse?: (EInnsynId | Dokumentbeskrivelse.Dokumentbeskrivelse)[];
  }
}

namespace Journalpost {
  /* Journalpost */
  @extension("x-resourceId", "Journalpost")
  @extension("x-idPrefix", "jp")
  model Journalpost extends Registrering.Registrering {
    @visibility("read") entity?: "Journalpost";
    @minValue(1900) journalaar: integer;
    @minValue(0) journalsekvensnummer: integer;
    @minValue(0) journalpostnummer: integer;
    journalposttype: string;
    journaldato: plainDate;
    dokumentetsDato?: plainDate;
    skjerming?: EInnsynId | Saksmappe.Saksmappe;
    @visibility("read") administrativEnhet: string;
    @visibility("read") administrativEnhetObjekt: EInnsynId | Enhet.Enhet;
    @visibility("read") sorteringstype: string;
    @visibility("read") saksmappe: EInnsynId | Saksmappe.Saksmappe;
  }

  @route("/journalpost")
  @tag("Journalpost")
  interface JournalpostRoutes extends Routable<Journalpost, "Journalpost"> {
    @route("/{journalpostId}/korrespondansepart")
    @get
    getKorrespondansepartList(
      ...QueryParameters.ListParameters,
      @path journalpostId: EInnsynId,
    ): Responses.ListResponse<Korrespondansepart.Korrespondansepart>;

    @route("/{journalpostId}/korrespondansepart")
    @post
    addKorrespondansepart(
      @path journalpostId: EInnsynId,
      @body korrespondansepart: Korrespondansepart.Korrespondansepart,
    ): Responses.AddResponse<Korrespondansepart.Korrespondansepart>;

    @route("/{journalpostId}/dokumentbeskrivelse")
    @get
    getDokumentbeskrivelseList(
      ...QueryParameters.ListParameters,
      @path journalpostId: EInnsynId,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{journalpostId}/dokumentbeskrivelse")
    @post
    addDokumentbeskrivelse(
      @path journalpostId: EInnsynId,
      @body dokumentbeskrivelse: Dokumentbeskrivelse.Dokumentbeskrivelse,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{journalpostId}/dokumentbeskrivelse/{dokumentbeskrivelseId}")
    @delete
    deleteDokumentbeskrivelse(
      @path journalpostId: EInnsynId,
      @path dokumentbeskrivelseId: EInnsynId,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Korrespondansepart {
  /* Korrespondansepart */
  @extension("x-resourceId", "Korrespondansepart")
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
  interface KorrespondansepartRoutes
    extends Routable<Korrespondansepart, "Korrespondansepart"> {}
}

namespace Skjerming {
  /* Skjerming */
  @extension("x-resourceId", "Skjerming")
  @extension("x-idPrefix", "skj")
  model Skjerming extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Skjerming";
    tilgangsrestriksjon: string;
    skjermingshjemmel?: string;
  }

  @route("/skjerming")
  @tag("Skjerming")
  interface SkjermingRoutes extends GloballyRoutable<Skjerming, "Skjerming"> {}
}

namespace Moetesak {
  /* Moetesak */
  @extension("x-resourceId", "Moetesak")
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
    @visibility("read") utvalgObjekt: EInnsynId | Enhet.Enhet;
    videoLink?: string;
    utredning?: EInnsynId | Utredning.Utredning;
    innstilling?: EInnsynId | Moetesaksbeskrivelse.Moetesaksbeskrivelse;
    vedtak?: EInnsynId | Vedtak.Vedtak;
    moetemappe?: EInnsynId | Moetemappe.Moetemappe;
  }

  @route("/moetesak")
  @tag("Moetesak")
  interface MoetesakRoutes extends Routable<Moetesak, "Moetesak"> {
    @route("/{moetesakId}/dokumentbeskrivelse")
    @get
    getDokumentbeskrivelseList(
      ...QueryParameters.ListParameters,
      @path moetesakId: EInnsynId,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{moetesakId}/dokumentbeskrivelse")
    @post
    addDokumentbeskrivelse(
      @path moetesakId: EInnsynId,
      @body dokumentbeskrivelse: Dokumentbeskrivelse.Dokumentbeskrivelse,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{moetesakId}/utredning")
    @get
    getUtredning(
      @path moetesakId: EInnsynId,
    ): Responses.OkResponse<Utredning.Utredning>;

    @route("/{moetesakId}/utredning")
    @post
    addUtredning(
      @path moetesakId: EInnsynId,
      @body utredning: Utredning.Utredning,
    ): Responses.AddResponse<Utredning.Utredning>;

    @route("/{moetesakId}/vedtak")
    @get
    getVedtak(@path moetesakId: EInnsynId): Responses.OkResponse<Vedtak.Vedtak>;

    @route("/{moetesakId}/vedtak")
    @post
    addVedtak(
      @path moetesakId: EInnsynId,
      @body vedtak: Vedtak.Vedtak,
    ): Responses.AddResponse<Vedtak.Vedtak>;
  }
}

namespace Utredning {
  /* Utredning */
  @extension("x-resourceId", "Utredning")
  @extension("x-idPrefix", "utr")
  model Utredning extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Utredning";
    saksbeskrivelse: EInnsynId | Moetesaksbeskrivelse.Moetesaksbeskrivelse;
    innstilling: EInnsynId | Moetesaksbeskrivelse.Moetesaksbeskrivelse;
    utredningsdokument?: (EInnsynId | Dokumentbeskrivelse.Dokumentbeskrivelse)[];
  }

  @route("/utredning")
  @tag("Utredning")
  interface UtredningRoutes extends Routable<Utredning, "Utredning"> {
    @route("/{utredningId}/utredningsdokument")
    @get
    getDokumentbeskrivelseList(
      ...QueryParameters.ListParameters,
      @path utredningId: EInnsynId,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{utredningId}/utredningsdokument")
    @post
    addDokumentbeskrivelse(
      @path utredningId: EInnsynId,
      @body dokumentbeskrivelse: Dokumentbeskrivelse.Dokumentbeskrivelse,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{utredningId}/utredningsdokument/{utredningsdokumentId}")
    @delete
    deleteDokumentbeskrivelse(
      @path utredningId: EInnsynId,
      @path utredningsdokumentId: EInnsynId,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Vedtak {
  /* Vedtak */
  @extension("x-resourceId", "Vedtak")
  @extension("x-idPrefix", "ved")
  model Vedtak extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Vedtak";
    vedtakstekst: EInnsynId | Moetesaksbeskrivelse.Moetesaksbeskrivelse;
    votering?: (EInnsynId | Votering.Votering)[];
    foo?: string[];
    behandlingsprotokoll?: EInnsynId | Behandlingsprotokoll.Behandlingsprotokoll;
    vedtaksdokument?: (EInnsynId | Dokumentbeskrivelse.Dokumentbeskrivelse)[];
    dato: plainDate;
  }

  @route("/vedtak")
  @tag("Vedtak")
  interface VedtakRoutes extends Routable<Vedtak, "Vedtak"> {
    @route("/{vedtakId}/votering")
    @get
    getVoteringList(
      ...QueryParameters.ListParameters,
      @path vedtakId: EInnsynId,
    ): Responses.ListResponse<Votering.Votering>;

    @route("/{vedtakId}/votering")
    @post
    addVotering(
      @path vedtakId: EInnsynId,
      @body votering: Votering.Votering,
    ): Responses.AddResponse<Votering.Votering>;

    @route("/{vedtakId}/vedtaksdokument")
    @get
    getDokumentbeskrivelseList(
      ...QueryParameters.ListParameters,
      @path vedtakId: EInnsynId,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{vedtakId}/vedtaksdokument")
    @post
    addDokumentbeskrivelse(
      @path vedtakId: EInnsynId,
      @body dokumentbeskrivelse: Dokumentbeskrivelse.Dokumentbeskrivelse,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{vedtakId}/vedtaksdokument/{vedtaksdokumentId}")
    @delete
    deleteDokumentbeskrivelse(
      @path vedtakId: EInnsynId,
      @path vedtaksdokumentId: EInnsynId,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Votering {
  /* Votering */
  @extension("x-resourceId", "Votering")
  @extension("x-idPrefix", "vot")
  model Votering extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Votering";
    moetedeltaker: EInnsynId | Moetedeltaker.Moetedeltaker;
    stemme: "Ja" | "Nei" | "Blankt";
    representerer?: EInnsynId | Identifikator.Identifikator;
  }

  @route("/votering")
  @tag("Votering")
  interface VoteringRoutes extends Routable<Votering, "Votering"> {}
}

namespace Moetesaksbeskrivelse {
  /* Moetesaksbeskrivelse */
  @extension("x-resourceId", "Moetesaksbeskrivelse")
  @extension("x-idPrefix", "msb")
  model Moetesaksbeskrivelse extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Moetesaksbeskrivelse";
    tekstInnhold: string;
    tekstFormat: string;
  }

  @route("/moetesaksbeskrivelse")
  @tag("Moetesaksbeskrivelse")
  interface MoetesaksbeskrivelseRoutes
    extends Routable<Moetesaksbeskrivelse, "Moetesaksbeskrivelse"> {}
}

namespace Behandlingsprotokoll {
  /* Behandlingsprotokoll */
  @extension("x-resourceId", "Behandlingsprotokoll")
  @extension("x-idPrefix", "bp")
  model Behandlingsprotokoll extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Behandlingsprotokoll";
    tekstInnhold: string;
    tekstFormat: string;
  }

  @route("/behandlingsprotokoll")
  @tag("Behandlingsprotokoll")
  interface BehandlingsprotokollRoutes
    extends Routable<Behandlingsprotokoll, "Behandlingsprotokoll"> {}
}

namespace Moetedeltaker {
  /* Moetedeltaker */
  @extension("x-resourceId", "Moetedeltaker")
  @extension("x-idPrefix", "md")
  model Moetedeltaker extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Moetedeltaker";
    moetedeltakerNavn: string;
    moetedeltakerFunksjon?: string;
  }

  @route("/moetedeltaker")
  @tag("Moetedeltaker")
  interface MoetedeltakerRoutes
    extends Routable<Moetedeltaker, "Moetedeltaker"> {}
}

namespace Identifikator {
  /**
   * Identifikator
   */
  @extension("x-resourceId", "Identifikator")
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
  interface IdentifikatorRoutes
    extends Routable<Identifikator, "Identifikator"> {}
}

namespace Dokumentbeskrivelse {
  /**
   * Dokumentbeskrivelse
   */
  @extension("x-resourceId", "Dokumentbeskrivelse")
  @extension("x-idPrefix", "db")
  model Dokumentbeskrivelse extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Dokumentbeskrivelse";
    tittel: string;
    tittelSensitiv: string;
    dokumentnummer: integer;
    dokumenttype?: string;
    tilknyttetRegistreringSom: string;
    dokumentobjekt?: (EInnsynId | Dokumentobjekt.Dokumentobjekt)[];
  }

  @route("/dokumentbeskrivelse")
  @tag("Dokumentbeskrivelse")
  interface DokumentbeskrivelseRoutes
    extends Routable<Dokumentbeskrivelse, "Dokumentbeskrivelse"> {
    @route("/dokumentbeskrivelse/{dokumentbeskrivelseId}/download/{subId}.{docExtension}")
    @get
    downloadDokumentbeskrivelse(
      @path dokumentbeskrivelseId: EInnsynId,
      @path subId: string,
      @path docExtension: string,
    ): Response<200>;
  }
}

namespace Dokumentobjekt {
  @extension("x-resourceId", "Dokumentobjekt")
  @extension("x-idPrefix", "do")
  model Dokumentobjekt extends ArkivBase.ArkivBase {
    @visibility("read") entity?: "Dokumentobjekt";
    referanseDokumentfil: url;
    format?: string;
    sjekksum?: string;
    sjekksumAlgoritme?: string;
    dokumentbeskrivelse?: EInnsynId | Dokumentbeskrivelse.Dokumentbeskrivelse;
  }

  @route("/dokumentobjekt")
  @tag("Dokumentobjekt")
  interface DokumentobjektRoutes
    extends Routable<Dokumentobjekt, "Dokumentobjekt"> {}
}

namespace Moetedokument {
  @extension("x-resourceId", "Moetedokument")
  @extension("x-idPrefix", "mdok")
  model Moetedokument extends Registrering.Registrering {
    @visibility("read") entity?: "Moetedokument";
    moetedokumenttype: string;
    saksbehandler?: string;
    saksbehandlerSensitiv?: string;
    moetemappe?: EInnsynId | Moetemappe.Moetemappe;
  }

  @route("/moetedokument")
  @tag("Moetedokument")
  interface MoetedokumentRoutes
    extends Routable<Moetedokument, "Moetedokument"> {
    @route("/{moetedokumentId}/dokumentbeskrivelse")
    @get
    getDokumentbeskrivelseList(
      ...QueryParameters.ListParameters,
      @path moetedokumentId: EInnsynId,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{moetedokumentId}/dokumentbeskrivelse")
    @post
    addDokumentbeskrivelse(
      @path moetedokumentId: EInnsynId,
      @body dokumentbeskrivelse: Dokumentbeskrivelse.Dokumentbeskrivelse,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}
