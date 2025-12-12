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
   * Represents a subdivision of an archive (Arkiv). In the Noark 5 standard, an archive can be divided into one or more archive parts.
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
   * Represents a record of proceedings, often related to a decision-making process in a meeting.
   */
  @extension("x-idPrefix", "bp")
  model Behandlingsprotokoll extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Behandlingsprotokoll";

    /** The content of the protocol. */
    tekstInnhold: string;

    /** The format of the content (e.g., "text/html"). */
    tekstFormat: string;
  }
}

namespace Dokumentbeskrivelse {
  /**
   * Represents the metadata for a document. It is connected to a registry entry and describes a single document.
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

    /** The document number within the parent registry entry. */
    dokumentnummer: integer;

    /** The type of document (e.g., 'letter', 'invoice'). */
    dokumenttype?: string;

    /** Describes the document's role in relation to the registry entry (e.g., 'main document', 'attachment'). */
    tilknyttetRegistreringSom: string;

    /** The associated electronic document(s). */
    dokumentobjekt?: ExpandableField<Dokumentobjekt.Dokumentobjekt>[];
  }
}

namespace Dokumentobjekt {
  /**
   * Represents an electronic document or file. It contains information needed to locate and render the document.
   */
  @extension("x-idPrefix", "do")
  model Dokumentobjekt extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Dokumentobjekt";

    /** A reference (URL) to the document file. */
    referanseDokumentfil: url;

    /** The file format of the document (e.g., 'PDF/A'). */
    format?: string;

    /** The checksum of the document file, for integrity verification. */
    sjekksum?: string;

    /** The algorithm used to calculate the checksum (e.g., 'SHA-256'). */
    sjekksumAlgoritme?: string;

    /** The document description this object belongs to. */
    dokumentbeskrivelse?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Enhet {
  /**
   * Represents an organizational unit within the public sector, such as a municipality, a government agency, or a department. This is a central model for identifying the public entities that own and manage the information in eInnsyn.
   */
  @extension("x-idPrefix", "enh")
  model Enhet extends Base.Base {
    @visibility(Lifecycle.Read) entity: "Enhet";

    /**
     * A URL-friendly unique slug for the resource.
     */
    @pattern("^[a-z0-9\\-]+$") slug?: string;

    /** The official name of the unit in Norwegian bokmål. */
    navn: string;

    /** The name of the unit in Norwegian nynorsk. */
    navnNynorsk?: string;

    /** The name of the unit in English. */
    navnEngelsk?: string;

    /** The name of the unit in Sami. */
    navnSami?: string;

    /** The 9-digit organization number from the Brønnøysund Register Centre. */
    @pattern("^[0-9]{9}$") orgnummer: string;

    /** An internal code or identifier for the unit. */
    enhetskode?: string;

    /** The postal address for the unit's contact point. */
    kontaktpunktAdresse?: string;

    /** The primary contact email address for the unit. */
    @format("email") kontaktpunktEpost: string;

    /** The primary contact phone number for the unit. */
    kontaktpunktTelefon?: string;

    /** The dedicated email address for receiving Freedom of Information (FOI) requests. */
    @format("email") innsynskravEpost: string;

    /** The type of the organizational unit. */
    @oneOf enhetstype:
      | "ADMINISTRATIVENHET" // Administrative unit
      | "AVDELING" // Department
      | "BYDEL" // Borough
      | "DUMMYENHET" // Dummy unit for technical purposes
      | "FYLKE" // County
      | "KOMMUNE" // Municipality
      | "ORGAN" // A board or committee
      | "SEKSJON" // Section
      | "UTVALG" // Committee or board
      | "VIRKSOMHET"; // Agency or enterprise

    /** The date when the unit was officially dissolved or became inactive. */
    avsluttetDato?: plainDate;

    /** If true, this unit should be hidden from public view. */
    skjult?: boolean;

    /** If true, this unit is configured to use the eFormidling platform for digital communication. */
    eFormidling?: boolean;

    /** If true, this is a technical or system-internal unit, not a real-world organizational unit. */
    teknisk?: boolean;

    /** A flag indicating if legacy identifiers for this unit should be converted. */
    skalKonvertereId?: boolean;

    /** A flag indicating if the unit should receive receipts for submissions. */
    skalMottaKvittering?: boolean;

    /** A UI hint to display this unit as a top-level node in a hierarchy. */
    visToppnode?: boolean;

    /** The version of the order XML format used by this unit. */
    orderXmlVersjon?: integer;

    /** A list of sub-units belonging to this unit. */
    underenhet?: ExpandableField<Enhet>[];

    /** The unit that is responsible for handling tasks on behalf of this unit. */
    handteresAv?: ExpandableField<Enhet>;

    /** The parent unit in the organizational hierarchy. */
    parent?: ExpandableField<Enhet>;
  }
}

namespace Identifikator {
  /**
   * Represents an identifier for a person, such as a case officer or an author.
   */
  @extension("x-idPrefix", "ide")
  model Identifikator extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Identifikator";

    /** The full name of the person. */
    navn: string;

    /** A unique identifier for the person, often a username or an employee ID. */
    identifikator: string;

    /** The initials of the person. */
    initialer: string;

    /** The email address of the person. */
    @format("email") epostadresse: string;
  }
}

namespace Journalpost {
  /**
   * Represents a registry entry for a document, corresponding to the Journalpost in the Noark 5 standard. It is a record of an incoming, outgoing, or internal document.
   */
  @extension("x-idPrefix", "jp")
  model Journalpost extends Registrering.Registrering {
    @visibility(Lifecycle.Read) entity: "Journalpost";

    /** The year the registry entry was created. */
    @minValue(1700) journalaar: integer;

    /** The sequence number of the registry entry within the journal year. */
    @minValue(0) journalsekvensnummer: integer;

    /** The post number within the journal. */
    @minValue(0) journalpostnummer: integer;

    /** The type of registry entry. */
    journalposttype:
      | "inngaaende_dokument" // Incoming document
      | "utgaaende_dokument" // Outgoing document
      | "organinternt_dokument_uten_oppfoelging" // Internal document without follow-up
      | "organinternt_dokument_for_oppfoelging" // Internal document for follow-up
      | "saksframlegg" // Case presentation
      | "sakskart" // Case map
      | "moeteprotokoll" // Meeting protocol
      | "moetebok" // Meeting book
      | "ukjent"; // Unknown

    /** The date the registry entry was recorded. */
    journaldato: plainDate;

    /** The date of the document itself. */
    dokumentetsDato?: plainDate;

    /** Access control information for the registry entry. */
    skjerming?: ExpandableField<Skjerming.Skjerming>;

    /** Legacy field for the journal post type. */
    legacyJournalposttype?: string;

    /** Legacy field for references to related cases. */
    legacyFoelgsakenReferanse?: string[];

    /** The identifier of the administrative unit responsible for the registry entry. */
    administrativEnhet?: string;

    /** The full administrative unit object responsible for the registry entry (expandable reference). */
    administrativEnhetObjekt?: ExpandableField<Enhet.Enhet>;

    /** The case this record belongs to. */
    @visibility(Lifecycle.Read, Lifecycle.Update)
    saksmappe?: ExpandableField<Saksmappe.Saksmappe>;
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
   * Represents a classification system used to organize and retrieve cases and documents.
   */
  @extension("x-idPrefix", "ksys")
  model Klassifikasjonssystem extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Klassifikasjonssystem";

    /** The title of the classification system. */
    tittel: string;

    /**
     * The parent arkivdel.
     */
    @visibility(Lifecycle.Read) arkivdel: ExpandableField<Arkivdel.Arkivdel>;
  }
}

namespace Korrespondansepart {
  /**
   * Represents a correspondent, which is a sender or recipient of a document.
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

    /** The type of correspondent (e.g., 'sender', 'recipient'). */
    korrespondanseparttype: string;

    /** The case officer associated with this correspondent. */
    saksbehandler?: string;

    /** The email address of the correspondent. */
    epostadresse?: string;

    /** The postal code of the correspondent. */
    postnummer?: string;

    /** Indicates if the correspondent is the data controller. */
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
   * An abstract base model for case files (Saksmappe) and meeting records (Moetemappe). It contains common properties for these folder-like structures.
   */
  model Mappe extends ArkivBase.ArkivBase {
    /**
     * A URL-friendly unique slug for the resource.
     */
    @pattern("^[a-z0-9\\-]+$") slug?: string;

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
   * Represents a participant in a meeting.
   */
  @extension("x-idPrefix", "md")
  model Moetedeltaker extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Moetedeltaker";

    /** The name of the meeting participant. */
    moetedeltakerNavn: string;

    /** The function or role of the participant in the meeting (e.g., 'Chairperson'). */
    moetedeltakerFunksjon?: string;
  }
}

namespace Moetedokument {
  /**
   * Represents a document related to a meeting, such as an agenda or minutes.
   */
  @extension("x-idPrefix", "mdok")
  model Moetedokument extends Registrering.Registrering {
    @visibility(Lifecycle.Read) entity: "Moetedokument";

    /** The type of meeting document (e.g., 'Agenda', 'Minutes'). */
    moetedokumenttype: string;

    /** The case officer responsible for the document. */
    saksbehandler?: string;

    /** The case officer responsible for the document, including sensitive information. */
    saksbehandlerSensitiv?: string;

    /** The meeting this document belongs to. */
    moetemappe?: ExpandableField<Moetemappe.Moetemappe>;
  }
}

namespace Moetemappe {
  /**
   * Represents a meeting, containing information about a specific meeting.
   */
  @extension("x-idPrefix", "mm")
  model Moetemappe extends Mappe.Mappe {
    @visibility(Lifecycle.Read) entity: "Moetemappe";

    /** A unique number or identifier for the meeting. */
    moetenummer: string;

    /** The name of the committee or board holding the meeting. */
    utvalg: string;

    /** The committee or board holding the meeting. */
    @visibility(Lifecycle.Read) utvalgObjekt: ExpandableField<Enhet.Enhet>;

    /** The date and time of the meeting. */
    moetedato: utcDateTime;

    /** The location of the meeting. */
    moetested?: string;

    /** A link to a video recording of the meeting. */
    @maxLength(5000) videoLink?: string;

    /** A reference to the previous meeting. */
    referanseForrigeMoete?: ExpandableField<Moetemappe>;

    /** A reference to the next meeting. */
    referanseNesteMoete?: ExpandableField<Moetemappe>;

    /** Documents associated with the meeting. */
    moetedokument?: ExpandableField<Moetedokument.Moetedokument>[];

    /** Cases discussed in the meeting. */
    moetesak?: ExpandableField<Moetesak.Moetesak>[];
  }
}

namespace Moetesak {
  /**
   * Represents a case discussed in a meeting.
   */
  @extension("x-idPrefix", "ms")
  model Moetesak extends Registrering.Registrering {
    @visibility(Lifecycle.Read) entity: "Moetesak";

    /** The type of meeting case. */
    moetesakstype:
      | "moete"
      | "politisk"
      | "delegert"
      | "interpellasjon"
      | "godkjenning"
      | "orientering"
      | "referat"
      | "annet";

    /** The year of the meeting case. */
    @minValue(1700) moetesaksaar?: integer;

    /** The sequence number of the meeting case within the year. */
    @minValue(0) moetesakssekvensnummer?: integer;

    /** The name of the committee or board handling the case. */
    utvalg?: string;

    /** The committee or board handling the case. */
    @visibility(Lifecycle.Read) utvalgObjekt: ExpandableField<Enhet.Enhet>;

    /** A link to a video recording of the case discussion. */
    videoLink?: string;

    /** The report or investigation related to the case. */
    utredning?: ExpandableField<Utredning.Utredning>;

    /** The recommendation or proposition for the case. */
    innstilling?: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;

    /** The decision made in the case. */
    vedtak?: ExpandableField<Vedtak.Vedtak>;

    /** The meeting record this case belongs to. */
    moetemappe?: ExpandableField<Moetemappe.Moetemappe>;

    /** Legacy field for the meeting case type. */
    legacyMoetesakstype?: string;

    /** Legacy field for a reference to another meeting case. */
    legacyReferanseTilMoetesak?: string;
  }
}

namespace Moetesaksbeskrivelse {
  /**
   * Represents a textual description related to a meeting case, such as a recommendation or a report.
   */
  @extension("x-idPrefix", "msb")
  model Moetesaksbeskrivelse extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Moetesaksbeskrivelse";

    /** The text content of the description. */
    tekstInnhold: string;

    /** The format of the text content (e.g., "text/html"). */
    tekstFormat: string;
  }
}

namespace Registrering {
  /**
   * An abstract base model for registry entries, such as journal entries (Journalpost) and meeting-related entries (Moetesak, Moetedokument).
   */
  model Registrering extends ArkivBase.ArkivBase {
    /**
     * A URL-friendly unique slug for the resource.
     */
    @pattern("^[a-z0-9\\-]+$") slug?: string;

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
   * Represents a case file, which is a folder for collecting all documents related to a specific case.
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
   * Represents access control information for a resource, specifying restrictions and the legal basis for them.
   */
  @extension("x-idPrefix", "skj")
  model Skjerming extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Skjerming";

    /** The code for the access restriction. */
    tilgangsrestriksjon: string;

    /** The legal basis for the access restriction (a reference to a law or regulation). */
    skjermingshjemmel?: string;
  }
}

namespace Utredning {
  /**
   * Represents a report or investigation related to a meeting case.
   */
  @extension("x-idPrefix", "utr")
  model Utredning extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Utredning";

    /** The description of the case. */
    saksbeskrivelse: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;

    /** The recommendation or proposition. */
    innstilling: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;

    /** Documents that are part of the investigation. */
    utredningsdokument?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>[];
  }
}

namespace Vedtak {
  /**
   * Represents a decision made in a meeting case.
   */
  @extension("x-idPrefix", "ved")
  model Vedtak extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Vedtak";

    /** The text of the decision. */
    vedtakstekst: ExpandableField<Moetesaksbeskrivelse.Moetesaksbeskrivelse>;

    /** The voting results related to the decision. */
    votering?: ExpandableField<Votering.Votering>[];

    /** The protocol of proceedings for the decision. */
    behandlingsprotokoll?: ExpandableField<Behandlingsprotokoll.Behandlingsprotokoll>;

    /** The document containing the decision. */
    vedtaksdokument?: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>[];

    /** The date the decision was made. */
    dato: plainDate;
  }
}

namespace Votering {
  /**
   * Represents a vote cast by a participant in a meeting.
   */
  @extension("x-idPrefix", "vot")
  model Votering extends ArkivBase.ArkivBase {
    @visibility(Lifecycle.Read) entity: "Votering";

    /** The meeting participant who cast the vote. */
    moetedeltaker: ExpandableField<Moetedeltaker.Moetedeltaker>;

    /** The vote cast ('Ja' for yes, 'Nei' for no, 'Blankt' for blank). */
    stemme: "Ja" | "Nei" | "Blankt";

    /** The person or party the participant is representing, if applicable. */
    representerer?: ExpandableField<Identifikator.Identifikator>;
  }
}
