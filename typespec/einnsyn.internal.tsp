import "@typespec/openapi3";


alias EInnsynId = string;


/* Base model for all eInnsyn objects. */
model EInnsynModel {
  /** The unique identifier for the resource. This is assigned by the system when the resource is created. */
  @visibility("read") id: string;

  /** A timestamp of when the resource was created. This field is updated automatically. */
  @visibility("read") created: string;

  /** A timestamp of when the resource was last updated. This field is updated automatically. */
  @visibility("read") updated: string;

  /** This field is only present if the resource has been deleted. If present, it will always be `true`. */
  @visibility("read") deleted: boolean;

  /** An external ID for the resource. This is similar to "systemId", but will be used for legacy IRIs that were used in earlier eInnsyn versions. */
  externalId?: string;
}


/* Enhet */
model EnhetModel extends EInnsynModel {
  @visibility("read") entity: "Enhet";
  navn: string;
  navnNynorsk?: string;
  navnEngelsk?: string;
  navnSami?: string;
  @pattern("^[0-9]{9}$") orgnummer: string;
  enhetskode?: string;
  kontaktpunktAdresse?: string;
  kontaktpunktEpost: string;
  kontaktpunktTelefon?: string;
  innsynskravEpost: string;
  enhetstype: "ADMINISTRATIVENHET" | "AVDELING" | "BYDEL" | "DUMMYENHET" | "FYLKE" | "KOMMUNE" | "ORGAN" | "SEKSJON" | "UTVALG" | "VIRKSOMHET";
  avsluttetDato?: string;
  skjult?: boolean;
  eFormidling?: boolean;
  teknisk?: boolean;
  skalKonvertereId?: boolean;
  skalMottaKvittering?: boolean;
  visToppnode?: boolean;
  orderXmlVersjon?: number;
  underenhet?: (EInnsynId | EnhetModel)[];
  handteresAv?: EInnsynId | EnhetModel;
  parent?: EInnsynId | EnhetModel;
}


/* Bruker */
model BrukerModel extends EInnsynModel {
  @visibility("read") entity: "Bruker";
  email: string;
  password: password;
  @visibility("read") active: boolean;
  language?: "nb" | "nn" | "en" | "se";
  lagretSak?: SakModel[];
  lagretSoek?: SoekModel[];
  innsynskrav?: InnsynskravModel[];
  innsynskravDel?: InnsynskravDelModel[];
}
