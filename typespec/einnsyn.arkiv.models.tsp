import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using TypeSpec.OpenAPI;

namespace EInnsyn;

/**
 * An eInnsynId is a Base32 encoded UUID, with a prefix to indicate the type of resource. All objects in eInnsyn has an eInnsynId.
 */
@format("id")
scalar eInnsynId<T = null> extends string;

/**
 * An expandable field is a field that can either be a reference to another resource by it's eInnsynId, or the full resource itself.
 */
alias ExpandableField<T> = eInnsynId<T> | T;

namespace Base {
  model Base {
    /**
     * The unique identifier for the resource. This is is assigned by the system when the resource is created.
     */
    @visibility(Lifecycle.Read) id: eInnsynId;

    /**
     * This field is only present if the resource has been deleted. If present, it will always be `true`.
     */
    @visibility(Lifecycle.Read) deleted: boolean;

    /**
     * An external ID for the resource. This is similar to "systemId", but will be used for legacy IRIs that were used in earlier eInnsyn versions.
     */
    externalId?: string;

    /**
     * This object should not be accessible to the public before the given dateTime.
     */
    accessibleAfter?: utcDateTime;
  }
}

namespace ArkivBase {
  /**
   * Properties shared by all Noark objects
   */
  model ArkivBase extends Base.Base {
    /**
     * The unique identifier for the resource, given by the user's system.
     */
    @format("id") systemId?: string;

    /**
     * The administrative unit that is responsible for the resource. This
     * is by default derived from the credentials used to authenticate the
     * request on creation, or it can manually be set to an Enhet owned by
     * that derived Enhet.
     */
    journalenhet?: ExpandableField<Enhet.Enhet>;
  }
}

namespace Arkiv {
  /**
   * Represents a top-level archive in the Noark structure.
   */
  @extension("x-idPrefix", "ark")
  model Arkiv extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Arkiv";

    /**
     * The title of the archive.
     */
    tittel: string;

    /**
     * The parent archive to which this archive belongs.
     */
    arkiv?: ExpandableField<Arkiv>;
  }
}

namespace Arkivdel {
  /**
   * Arkivdel
   */
  @extension("x-idPrefix", "arkd")
  model Arkivdel extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Arkivdel";

    /**
     * The title of the Arkivdel.
     */
    tittel: string;

    /**
     * The parent Arkiv to which this Arkivdel belongs.
     */
    @visibility(Lifecycle.Read) arkiv: ExpandableField<Arkiv.Arkiv>;
  }
}

namespace Behandlingsprotokoll {
  /**
   * Behandlingsprotokoll
   */
  @extension("x-idPrefix", "bp")
  model Behandlingsprotokoll extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Behandlingsprotokoll";
    tekstInnhold: string;
    tekstFormat: string;
  }
}

namespace Dokumentbeskrivelse {
  /**
   * Dokumentbeskrivelse
   */
  @extension("x-idPrefix", "db")
  model Dokumentbeskrivelse extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Dokumentbeskrivelse";

    /**
     * The title of the document, with sensitive information redacted.
     */
    tittel: string;

    /**
     * The title of the document, with sensitive information included.
     */
    tittelSensitiv: string;

    dokumentnummer: integer;
    dokumenttype?: string;
    tilknyttetRegistreringSom: string;
    dokumentobjekt?: ExpandableField<Dokumentobjekt.Dokumentobjekt>[];
  }
}

namespace Dokumentobjekt {
  @extension("x-idPrefix", "do")
  model Dokumentobjekt extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Dokumentobjekt";
    referanseDokumentfil: url;
    format?: string;
    sjekksum?: string;
    sjekksumAlgoritme?: string;
    dokumentbeskrivelse?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Enhet {
  /**
   * eInnsyn Enhet
   */
  @extension("x-idPrefix", "enh")
  model Enhet extends Base.Base {
    @visibility(Lifecycle.Read) entity: "Enhet";
    navn: string;
    navnNynorsk?: string;
    navnEngelsk?: string;
    navnSami?: string;
    @pattern("^[0-9]{9}$") orgnummer: string;
    enhetskode?: string;
    kontaktpunktAdresse?: string;
    @format("email") kontaktpunktEpost: string;
    kontaktpunktTelefon?: string;
    @format("email") innsynskravEpost: string;
    @oneOf enhetstype:
      | "ADMINISTRATIVENHET"
      | "AVDELING"
      | "BYDEL"
      | "DUMMYENHET"
      | "FYLKE"
      | "KOMMUNE"
      | "ORGAN"
      | "SEKSJON"
      | "UTVALG"
      | "VIRKSOMHET";
    avsluttetDato?: plainDate;
    skjult?: boolean;
    eFormidling?: boolean;
    teknisk?: boolean;
    skalKonvertereId?: boolean;
    skalMottaKvittering?: boolean;
    visToppnode?: boolean;
    orderXmlVersjon?: integer;
    underenhet?: ExpandableField<Enhet>[];
    handteresAv?: ExpandableField<Enhet>;
    parent?: ExpandableField<Enhet>;
  }
}

namespace Identifikator {
  /**
   * Identifikator
   */
  @extension("x-idPrefix", "ide")
  model Identifikator extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Identifikator";
    navn: string;
    identifikator: string;
    initialer: string;
    @format("email") epostadresse: string;
  }
}

namespace Journalpost {
  /**
   * Journalpost
   */
  @extension("x-idPrefix", "jp")
  model Journalpost extends Registrering.Registrering {
    @visibility(Lifecycle.Read) entity: "Journalpost";
    @minValue(1700) journalaar: integer;
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
    skjerming?: ExpandableField<Skjerming.Skjerming>;
    legacyJournalposttype?: string;
    legacyFoelgsakenReferanse?: string[];
    administrativEnhet?: string;
    administrativEnhetObjekt?: ExpandableField<Enhet.Enhet>;
    @visibility(Lifecycle.Read, Lifecycle.Update) saksmappe?: ExpandableField<Saksmappe.Saksmappe>;
  }
}

namespace Klasse {
  /**
   * Klasse
   */
  @extension("x-idPrefix", "kla")
  model Klasse extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Klasse";

    /**
     * The title of the class.
     */
    tittel: string;

    /**
     * An optional parent klassifikasjonssystem
     */
    klassifikasjonssystem?: ExpandableField<Klassifikasjonssystem.Klassifikasjonssystem>;

    /**
     * An optional parent klasse
     */
    klasse?: ExpandableField<Klasse>;

    /**
     * An optional parent arkivdel (non-standard field, due to legacy data)
     */
    arkivdel?: ExpandableField<Arkivdel.Arkivdel>;
  }
}

namespace Klassifikasjonssystem {
  /**
   * Klassifikasjonssystem
   */
  @extension("x-idPrefix", "ksys")
  model Klassifikasjonssystem extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Klassifikasjonssystem";
    tittel: string;

    /**
     * The parent arkivdel.
     */
    @visibility(Lifecycle.Read) arkivdel: ExpandableField<Arkivdel.Arkivdel>;
  }
}

namespace Korrespondansepart {
  /**
   * Korrespondansepart
   */
  @extension("x-idPrefix", "kp")
  model Korrespondansepart extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Korrespondansepart";

    /**
     * The name of the Korrespondansepart, with sensitive parts redacted.
     */
    korrespondansepartNavn: string;

    /**
     * The name of the Korrespondansepart, with all parts included.
     */
    korrespondansepartNavnSensitiv: string;

    korrespondanseparttype: string;
    saksbehandler?: string;
    epostadresse?: string;
    postnummer?: string;
    erBehandlingsansvarlig?: boolean;

    /**
     * The code for the administrative Enhet associated with this Korrespondansepart.
     */
    administrativEnhet?: string;

    /**
     * The Journalpost this Korrespondansepart is associated with, if any.
     */
    @visibility(Lifecycle.Read)
    journalpost?: ExpandableField<Journalpost.Journalpost>;

    /**
     * The Moetedokument this Korrespondansepart is associated with, if any.
     */
    @visibility(Lifecycle.Read)
    moetedokument?: ExpandableField<Moetedokument.Moetedokument>;

    /**
     * The Moetesak this Korrespondansepart is associated with, if any.
     */
    @visibility(Lifecycle.Read) moetesak?: ExpandableField<Moetesak.Moetesak>;
  }
}

namespace Mappe {
  /**
   * Mappe
   */
  model Mappe extends ArkivBase.ArkivBase {
    /**
     * The title of the Mappe, with sensitive information redacted.
     */
    offentligTittel: string;

    /**
     * The title of the Mappe, with sensitive information included.
     */
    offentligTittelSensitiv: string;

    @maxLength(1000) beskrivelse?: string;

    noekkelord?: string;

    /**
     * The date the resource was published. This field is updated automatically, but can be set manually by admins.
     */
    publisertDato?: utcDateTime;

    /**
     * The date the resource was last updated. This field is updated automatically, but can be set manually by admins.
     */
    oppdatertDato?: utcDateTime;

    /**
     * An optional Klasse for this Mappe.
     */
    klasse?: ExpandableField<Klasse.Klasse>;

    /**
     * If this Mappe is the child of a Saksmappe, this field will contain the parent Saksmappe.
     */
    @visibility(Lifecycle.Read)
    saksmappe?: ExpandableField<Saksmappe.Saksmappe>;

    /**
     * If this Mappe is the child of a Moetemappe, this field will contain the parent Moetemappe.
     */
    @visibility(Lifecycle.Read)
    moetemappe?: ExpandableField<Moetemappe.Moetemappe>;

    /**
     * If this Mappe is not a child of a Saksmappe or Moetemappe, this field will contain the parent Arkivdel.
     */
    @visibility(Lifecycle.Read) arkivdel?: ExpandableField<Arkivdel.Arkivdel>;
  }
}

namespace Moetedeltaker {
  /**
   * Moetedeltaker
   */
  @extension("x-idPrefix", "md")
  model Moetedeltaker extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Moetedeltaker";
    moetedeltakerNavn: string;
    moetedeltakerFunksjon?: string;
  }
}

namespace Moetedokument {
  /**
   * Moetedokument
   */
  @extension("x-idPrefix", "mdok")
  model Moetedokument extends Registrering.Registrering {
    @visibility(Lifecycle.Read) entity: "Moetedokument";
    moetedokumenttype: string;
    saksbehandler?: string;
    saksbehandlerSensitiv?: string;
    moetemappe?: ExpandableField<Moetemappe.Moetemappe>;
  }
}

namespace Moetemappe {
  /**
   * Moetemappe
   */
  @extension("x-idPrefix", "mm")
  model Moetemappe extends Mappe.Mappe {
    @visibility(Lifecycle.Read) entity: "Moetemappe";
    moetenummer: string;
    utvalg: string;
    @visibility(Lifecycle.Read) utvalgObjekt: ExpandableField<Enhet.Enhet>;
    moetedato: utcDateTime;
    moetested?: string;
    @maxLength(5000) videoLink?: string;
    referanseForrigeMoete?: ExpandableField<Moetemappe>;
    referanseNesteMoete?: ExpandableField<Moetemappe>;
    moetedokument?: ExpandableField<Moetedokument.Moetedokument>[];
    moetesak?: ExpandableField<Moetesak.Moetesak>[];
  }
}

namespace Moetesak {
  /**
   * Moetesak
   */
  @extension("x-idPrefix", "ms")
  model Moetesak extends Registrering.Registrering {
    @visibility(Lifecycle.Read) entity: "Moetesak";
    moetesakstype:
      | "moete"
      | "politisk"
      | "delegert"
      | "interpellasjon"
      | "godkjenning"
      | "orientering"
      | "referat"
      | "annet";
    @minValue(1700) moetesaksaar?: integer;
    @minValue(0) moetesakssekvensnummer?: integer;
    utvalg?: string;
    @visibility(Lifecycle.Read) utvalgObjekt: ExpandableField<Enhet.Enhet>;
    videoLink?: string;
    utredning?: ExpandableField<Utredning.Utredning>;
    innstilling?: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;
    vedtak?: ExpandableField<Vedtak.Vedtak>;
    moetemappe?: ExpandableField<Moetemappe.Moetemappe>;
    legacyMoetesakstype?: string;
    legacyReferanseTilMoetesak?: string;
  }
}

namespace Moetesaksbeskrivelse {
  /**
   * Moetesaksbeskrivelse
   */
  @extension("x-idPrefix", "msb")
  model Moetesaksbeskrivelse extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Moetesaksbeskrivelse";
    tekstInnhold: string;
    tekstFormat: string;
  }
}

namespace Registrering {
  /**
   * Registrering
   */
  model Registrering extends ArkivBase.ArkivBase {
    /**
     * The title of the resource, with sensitive information redacted.
     */
    offentligTittel: string;

    /**
     * The title of the resource, with sensitive information included.
     */
    offentligTittelSensitiv: string;

    @maxLength(1000) beskrivelse?: string;

    /**
     * The date the resource was published. This field is updated automatically, but can be set manually by admins.
     */
    publisertDato?: utcDateTime;

    /**
     * The date the resource was last updated. This field is updated automatically, but can be set manually by admins.
     */
    oppdatertDato?: utcDateTime;

    korrespondansepart?: ExpandableField<Korrespondansepart.Korrespondansepart>[];
    dokumentbeskrivelse?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>[];

    /**
     * The administrative unit that has been handed the responsibility for this resource.
     */
    avhendetTil?: ExpandableField<Enhet.Enhet>;
  }
}

namespace Saksmappe {
  /**
   * Saksmappe
   */
  @extension("x-idPrefix", "sm")
  model Saksmappe extends Mappe.Mappe {
    @visibility(Lifecycle.Read) entity: "Saksmappe";
    @minValue(1700) saksaar: integer;
    @minValue(0) sakssekvensnummer: integer;
    @visibility(Lifecycle.Read) saksnummer: string;
    saksdato?: plainDate;

    /**
     * A list of journalposts associated with this Saksmappe. This is write-only, reads should use the separate `journalpost` endpoint.
     */
    @visibility(Lifecycle.Create, Lifecycle.Update)
    journalpost?: ExpandableField<Journalpost.Journalpost>[];

    /**
     * A code for the administrative Enhet associated with this Saksmappe.
     */
    administrativEnhet?: string;

    /**
     * The administrative Enhet associated with this Saksmappe. This is derived from the code given in `administrativEnhet`.
     * If no `administrativEnhet` is given, or the code is not found, the `journalenhet` of the authenticated user will be used.
     */
    @visibility(Lifecycle.Read)
    administrativEnhetObjekt: ExpandableField<Enhet.Enhet>;
  }
}

namespace Skjerming {
  /**
   * Skjerming
   */
  @extension("x-idPrefix", "skj")
  model Skjerming extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Skjerming";
    tilgangsrestriksjon: string;
    skjermingshjemmel?: string;
  }
}

namespace Utredning {
  /**
   * Utredning
   */
  @extension("x-idPrefix", "utr")
  model Utredning extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Utredning";
    saksbeskrivelse: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;
    innstilling: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;
    utredningsdokument?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>[];
  }
}

namespace Vedtak {
  /**
   * Vedtak
   */
  @extension("x-idPrefix", "ved")
  model Vedtak extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Vedtak";
    vedtakstekst: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;
    votering?: ExpandableField<Votering.Votering>[];
    behandlingsprotokoll?: ExpandableField<Behandlingsprotokoll.Behandlingsprotokoll>;
    vedtaksdokument?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>[];
    dato: plainDate;
  }
}

namespace Votering {
  /**
   * Votering
   */
  @extension("x-idPrefix", "vot")
  model Votering extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Votering";
    moetedeltaker: ExpandableField<Moetedeltaker.Moetedeltaker>;
    stemme: "Ja" | "Nei" | "Blankt";
    representerer?: ExpandableField<Identifikator.Identifikator>;
  }
}
