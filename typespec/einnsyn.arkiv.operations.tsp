import "@typespec/http";
import "@typespec/openapi";
import "./einnsyn.arkiv.models.tsp";
import "./einnsyn.web.models.tsp";
import "./einnsyn.responses.tsp";
import "./einnsyn.queryparameters.tsp";

using TypeSpec.Http;

namespace EInnsyn;

/**
 * A standard routable object should have endpoints for List, Read, Update and Delete operations.
 * By default there is no endpoint for adding objects, this should be done through a parent object.
 */
interface Routable<T extends Base.Base> {
  /**
   * List all objects.
   */
  @route("")
  @get
  list(...QueryParameters.ListParameters): Responses.ListResponse<T>;

  /**
   * Get an object.
   * @param id The ID of the object.
   * @returns The object.
   */
  @route("/{id}")
  @get
  get(
    ...QueryParameters.GetParameters,
    @path id: eInnsynId<T>,
  ): Responses.OkResponse<T>;

  /**
   * Update an object.
   * @param id The ID of the object.
   * @returns The updated object.
   */
  @route("/{id}")
  @patch(#{ implicitOptionality: true })
  update(@path id: eInnsynId<T>, @body body: T): Responses.OkResponse<T>;

  /**
   * Delete an object.
   * @param id The ID of the object.
   * @returns The deleted object.
   */
  @route("/{id}")
  @delete
  delete(@path id: eInnsynId<T>): Responses.OkResponse<T>;
}

/**
 * A globally routable object should have the standard "Routable" endpoints, in addition to an "Add" endpoint without a known parent.
 */
interface GloballyRoutable<T extends Base.Base> extends Routable<T> {
  @route("")
  @post
  add(@body body: T): Responses.AddResponse<T>;
}

namespace ApiKey {
  @route("/apiKey")
  @tag("ApiKey")
  interface ApiKeyRoutes extends Routable<ApiKey> {}
}

namespace Arkiv {
  model ListByArkivParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Arkiv>;
    @query arkivId: eInnsynId<Arkiv>;
  }

  @route("/arkiv")
  @tag("Arkiv")
  interface ArkivRoutes extends GloballyRoutable<Arkiv> {
    @route("/{id}/arkivdel")
    @get
    listArkivdel(
      ...ListByArkivParameters,
    ): Responses.ListResponse<Arkivdel.Arkivdel>;

    @route("/{id}/arkivdel")
    @post
    addArkivdel(
      @path id: eInnsynId<Arkiv>,
      @body arkivdel: Arkivdel.Arkivdel,
    ): Responses.AddResponse<Arkivdel.Arkivdel>;

    @route("/{id}/arkiv")
    @get
    listArkiv(...ListByArkivParameters): Responses.ListResponse<Arkiv>;

    @route("/{id}/arkiv")
    @post
    addArkiv(
      @path id: eInnsynId<Arkiv>,
      @body arkiv: Arkiv,
    ): Responses.AddResponse<Arkiv>;
  }
}

namespace Arkivdel {
  model ListByArkivdelParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Arkivdel>;
    @query arkivdelId: eInnsynId<Arkivdel>;
  }

  @route("/arkivdel")
  @tag("Arkivdel")
  interface ArkivdelRoutes extends Routable<Arkivdel> {
    @route("/{id}/klasse")
    @get
    listKlasse(
      ...ListByArkivdelParameters,
    ): Responses.ListResponse<Klasse.Klasse>;

    @route("/{id}/klasse")
    @post
    addKlasse(
      @path id: eInnsynId<Arkivdel>,
      @body klasse: Klasse.Klasse,
    ): Responses.AddResponse<Klasse.Klasse>;

    @route("/{id}/klassifikasjonssystem")
    @get
    listKlassifikasjonssystem(
      ...ListByArkivdelParameters,
    ): Responses.ListResponse<Klassifikasjonssystem.Klassifikasjonssystem>;

    @route("/{id}/klassifikasjonssystem")
    @post
    addKlassifikasjonssystem(
      @path id: eInnsynId<Arkivdel>,
      @body klassifikasjonssystem: Klassifikasjonssystem.Klassifikasjonssystem,
    ): Responses.AddResponse<Klassifikasjonssystem.Klassifikasjonssystem>;

    @route("/{id}/saksmappe")
    @get
    listSaksmappe(
      ...ListByArkivdelParameters,
    ): Responses.ListResponse<Saksmappe.Saksmappe>;

    @route("/{id}/saksmappe")
    @post
    addSaksmappe(
      @path id: eInnsynId<Arkivdel>,
      @body saksmappe: Saksmappe.Saksmappe,
    ): Responses.AddResponse<Saksmappe.Saksmappe>;

    @route("/{id}/moetemappe")
    @get
    listMoetemappe(
      ...ListByArkivdelParameters,
    ): Responses.ListResponse<Moetemappe.Moetemappe>;

    @route("/{id}/moetemappe")
    @post
    addMoetemappe(
      @path id: eInnsynId<Arkivdel>,
      @body moetemappe: Moetemappe.Moetemappe,
    ): Responses.AddResponse<Moetemappe.Moetemappe>;
  }
}

namespace Behandlingsprotokoll {
  @route("/behandlingsprotokoll")
  @tag("Behandlingsprotokoll")
  interface BehandlingsprotokollRoutes extends Routable<Behandlingsprotokoll> {}
}

namespace Dokumentbeskrivelse {
  @route("/dokumentbeskrivelse")
  @tag("Dokumentbeskrivelse")
  interface DokumentbeskrivelseRoutes extends Routable<Dokumentbeskrivelse> {
    @route("/{id}/dokumentobjekt")
    @post
    addDokumentobjekt(
      @path id: eInnsynId<Dokumentbeskrivelse>,
      @body body: ExpandableField<Dokumentobjekt.Dokumentobjekt>,
    ): Responses.AddResponse<Dokumentobjekt.Dokumentobjekt>;
  }
}

namespace Dokumentobjekt {
  @route("/dokumentobjekt")
  @tag("Dokumentobjekt")
  interface DokumentobjektRoutes extends Routable<Dokumentobjekt> {}
}

namespace Enhet {
  model ListByEnhetParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Arkiv>;
    @query enhetId: eInnsynId<Enhet>;
  }

  @route("/enhet")
  @tag("Enhet")
  interface EnhetRoutes extends GloballyRoutable<Enhet> {
    @route("/{id}/underenhet")
    @get
    listUnderenhet(...ListByEnhetParameters): Responses.ListResponse<Enhet>;

    @route("/{id}/underenhet")
    @post
    addUnderenhet(
      @path id: eInnsynId<Enhet>,
      @body body: ExpandableField<Enhet>,
    ): Responses.AddResponse<Enhet>;

    @route("/{id}/apiKey")
    @get
    listApiKey(...ListByEnhetParameters): Responses.ListResponse<ApiKey.ApiKey>;

    @route("/{id}/apiKey")
    @post
    addApiKey(
      @path id: eInnsynId<Enhet>,
      @body body: ApiKey.ApiKey,
    ): Responses.AddResponse<ApiKey.ApiKey>;

    @route("/{id}/arkiv")
    @get
    listArkiv(...ListByEnhetParameters): Responses.ListResponse<Arkiv.Arkiv>;

    @route("/{id}/innsynskrav")
    @get
    listInnsynskrav(
      ...ListByEnhetParameters,
    ): Responses.ListResponse<Innsynskrav.Innsynskrav>;
  }
}

namespace Identifikator {
  @route("/identifikator")
  @tag("Identifikator")
  interface IdentifikatorRoutes extends Routable<Identifikator> {}
}

namespace Journalpost {
  model ListByJournalpostParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Journalpost>;
    @query journalpostId: eInnsynId<Journalpost>;
  }

  @route("/journalpost")
  @tag("Journalpost")
  interface JournalpostRoutes extends Routable<Journalpost> {
    @route("/{id}/korrespondansepart")
    @get
    listKorrespondansepart(
      ...ListByJournalpostParameters,
    ): Responses.ListResponse<Korrespondansepart.Korrespondansepart>;

    @route("/{id}/korrespondansepart")
    @post
    addKorrespondansepart(
      @path id: eInnsynId<Journalpost>,
      @body korrespondansepart: Korrespondansepart.Korrespondansepart,
    ): Responses.AddResponse<Korrespondansepart.Korrespondansepart>;

    @route("/{id}/dokumentbeskrivelse")
    @get
    listDokumentbeskrivelse(
      ...ListByJournalpostParameters,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/dokumentbeskrivelse")
    @post
    addDokumentbeskrivelse(
      @path id: eInnsynId<Journalpost>,

      @body
      dokumentbeskrivelse: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/dokumentbeskrivelse/{dokumentbeskrivelseId}")
    @delete
    deleteDokumentbeskrivelse(
      @path id: eInnsynId<Journalpost>,

      @path
      dokumentbeskrivelseId: eInnsynId<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/skjerming")
    @post
    addSkjerming(
      @path id: eInnsynId<Journalpost>,
      @body skjerming: ExpandableField<Skjerming.Skjerming>,
    ): Responses.AddResponse<Skjerming.Skjerming>;

    @route("/{id}/skjerming/{skjermingId}")
    @delete
    deleteSkjerming(
      @path id: eInnsynId<Journalpost>,
      @path skjermingId: eInnsynId<Skjerming.Skjerming>,
    ): Responses.OkResponse<Skjerming.Skjerming>;
  }
}

namespace Klasse {
  model ListByKlasseParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Klasse>;
    @query klasseId: eInnsynId<Klasse>;
  }

  @route("/klasse")
  @tag("Klasse")
  interface KlasseRoutes extends Routable<Klasse> {
    @route("/{id}/saksmappe")
    @get
    listSaksmappe(
      ...ListByKlasseParameters,
    ): Responses.ListResponse<Saksmappe.Saksmappe>;

    @route("/{id}/moetemappe")
    @get
    listMoetemappe(
      ...ListByKlasseParameters,
    ): Responses.ListResponse<Moetemappe.Moetemappe>;

    @route("/{id}/klasse")
    @get
    listKlasse(...ListByKlasseParameters): Responses.ListResponse<Klasse>;

    @route("/{id}/klasse")
    @post
    addKlasse(
      @path id: eInnsynId<Klasse>,
      @body klasse: Klasse,
    ): Responses.AddResponse<Klasse>;
  }
}

namespace Klassifikasjonssystem {
  model ListByKlassifikasjonssystemParameters
    extends QueryParameters.ListParameters {
    @path id: eInnsynId<Klassifikasjonssystem>;
    @query klassifikasjonssystemId: eInnsynId<Klassifikasjonssystem>;
  }

  @route("/klassifikasjonssystem")
  @tag("Klassifikasjonssystem")
  interface KlassifikasjonssystemRoutes
    extends Routable<Klassifikasjonssystem> {
    @route("/{id}/klasse")
    @get
    listKlasse(
      ...ListByKlassifikasjonssystemParameters,
    ): Responses.ListResponse<Klasse.Klasse>;

    @route("/{id}/klasse")
    @post
    addKlasse(
      @path id: eInnsynId<Klassifikasjonssystem>,
      @body klasse: Klasse.Klasse,
    ): Responses.AddResponse<Klasse.Klasse>;
  }
}

namespace Korrespondansepart {
  @route("/korrespondansepart")
  @tag("Korrespondansepart")
  interface KorrespondansepartRoutes extends Routable<Korrespondansepart> {}
}

namespace Moetedeltaker {
  @route("/moetedeltaker")
  @tag("Moetedeltaker")
  interface MoetedeltakerRoutes extends Routable<Moetedeltaker> {}
}

namespace Moetedokument {
  model ListByMoetedokumentParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Moetedokument>;
    @query moetedokumentId: eInnsynId<Moetedokument>;
  }

  @route("/moetedokument")
  @tag("Moetedokument")
  interface MoetedokumentRoutes extends Routable<Moetedokument> {
    @route("/{id}/dokumentbeskrivelse")
    @get
    listDokumentbeskrivelse(
      ...ListByMoetedokumentParameters,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/dokumentbeskrivelse")
    @post
    addDokumentbeskrivelse(
      @path id: eInnsynId<Moetedokument>,

      @body
      dokumentbeskrivelse: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/dokumentbeskrivelse/{dokumentbeskrivelseId}")
    @delete
    deleteDokumentbeskrivelse(
      @path id: eInnsynId<Moetedokument>,

      @path
      dokumentbeskrivelseId: eInnsynId<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Moetemappe {
  model ListByMoetemappeParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Moetemappe>;
    @query moetemappeId: eInnsynId<Moetemappe>;
  }

  @route("/moetemappe")
  @tag("Moetemappe")
  interface MoetemappeRoutes extends Routable<Moetemappe> {
    @route("/{id}/moetesak")
    @get
    listMoetesak(
      ...ListByMoetemappeParameters,
    ): Responses.ListResponse<Moetesak.Moetesak>;

    @route("/{id}/moetesak")
    @post
    addMoetesak(
      @path id: eInnsynId<Moetemappe>,
      @body moetesak: Moetesak.Moetesak,
    ): Responses.AddResponse<Moetesak.Moetesak>;

    @route("/{id}/moetedokument")
    @get
    listMoetedokument(
      ...ListByMoetemappeParameters,
    ): Responses.ListResponse<Moetedokument.Moetedokument>;

    @route("/{id}/moetedokument")
    @post
    addMoetedokument(
      @path id: eInnsynId<Moetemappe>,
      @body moetedokument: Moetedokument.Moetedokument,
    ): Responses.AddResponse<Moetedokument.Moetedokument>;
  }
}

namespace Moetesak {
  model ListByMoetesakParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Moetesak>;
    @query moetesakId: eInnsynId<Moetesak>;
  }

  model GetByMoetesakParameters extends QueryParameters.GetParameters {
    @path id: eInnsynId<Moetesak>;
    @query moetesakId: eInnsynId<Moetesak>;
  }

  @route("/moetesak")
  @tag("Moetesak")
  interface MoetesakRoutes extends GloballyRoutable<Moetesak> {
    @route("/{id}/dokumentbeskrivelse")
    @get
    listDokumentbeskrivelse(
      ...ListByMoetesakParameters,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/dokumentbeskrivelse")
    @post
    addDokumentbeskrivelse(
      @path id: eInnsynId<Moetesak>,

      @body
      dokumentbeskrivelse: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/dokumentbeskrivelse/{dokumentbeskrivelseId}")
    @delete
    deleteDokumentbeskrivelse(
      @path id: eInnsynId<Moetesak>,

      @path
      dokumentbeskrivelseId: eInnsynId<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/utredning")
    @get
    getUtredning(
      ...GetByMoetesakParameters,
    ): Responses.OkResponse<Utredning.Utredning>;

    @route("/{id}/utredning")
    @post
    addUtredning(
      @path id: eInnsynId<Moetesak>,
      @body utredning: Utredning.Utredning,
    ): Responses.AddResponse<Utredning.Utredning>;

    @route("/{id}/vedtak")
    @get
    getVedtak(...GetByMoetesakParameters): Responses.OkResponse<Vedtak.Vedtak>;

    @route("/{id}/vedtak")
    @post
    addVedtak(
      @path id: eInnsynId<Moetesak>,
      @body vedtak: Vedtak.Vedtak,
    ): Responses.AddResponse<Vedtak.Vedtak>;
  }
}

namespace Moetesaksbeskrivelse {
  @route("/moetesaksbeskrivelse")
  @tag("Moetesaksbeskrivelse")
  interface MoetesaksbeskrivelseRoutes extends Routable<Moetesaksbeskrivelse> {}
}

namespace Saksmappe {
  model ListBySaksmappeParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Saksmappe>;
    @query saksmappeId: eInnsynId<Saksmappe>;
  }

  @route("/saksmappe")
  @tag("Saksmappe")
  interface SaksmappeRoutes extends Routable<Saksmappe> {
    @route("/{id}/journalpost")
    @get
    listJournalpost(
      ...ListBySaksmappeParameters,
    ): Responses.ListResponse<Journalpost.Journalpost>;

    @route("/{id}/journalpost")
    @post
    addJournalpost(
      @path id: eInnsynId<Saksmappe>,
      @body journalpost: Journalpost.Journalpost,
    ): Responses.AddResponse<Journalpost.Journalpost>;
  }
}

namespace Skjerming {
  @route("/skjerming")
  @tag("Skjerming")
  interface SkjermingRoutes extends GloballyRoutable<Skjerming> {}
}

namespace Utredning {
  model ListByUtredningParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Utredning>;
    @query utredningId: eInnsynId<Utredning>;
  }

  @route("/utredning")
  @tag("Utredning")
  interface UtredningRoutes extends Routable<Utredning> {
    @route("/{id}/utredningsdokument")
    @get
    listUtredningsdokument(
      ...ListByUtredningParameters,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/utredningsdokument")
    @post
    addUtredningsdokument(
      @path id: eInnsynId<Utredning>,

      @body
      dokumentbeskrivelse: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/utredningsdokument/{utredningsdokumentId}")
    @delete
    deleteUtredningsdokument(
      @path id: eInnsynId<Utredning>,

      @path
      utredningsdokumentId: eInnsynId<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Vedtak {
  model ListByVedtakParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Vedtak>;
    @query vedtakId: eInnsynId<Vedtak>;
  }

  @route("/vedtak")
  @tag("Vedtak")
  interface VedtakRoutes extends Routable<Vedtak> {
    @route("/{id}/votering")
    @get
    listVotering(
      ...ListByVedtakParameters,
    ): Responses.ListResponse<Votering.Votering>;

    @route("/{id}/votering")
    @post
    addVotering(
      @path id: eInnsynId<Vedtak>,
      @body votering: Votering.Votering,
    ): Responses.AddResponse<Votering.Votering>;

    @route("/{id}/vedtaksdokument")
    @get
    listVedtaksdokument(
      ...ListByVedtakParameters,
    ): Responses.ListResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/vedtaksdokument")
    @post
    addVedtaksdokument(
      @path id: eInnsynId<Vedtak>,

      @body
      dokumentbeskrivelse: ExpandableField<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.AddResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;

    @route("/{id}/vedtaksdokument/{vedtaksdokumentId}")
    @delete
    deleteVedtaksdokument(
      @path id: eInnsynId<Vedtak>,

      @path
      vedtaksdokumentId: eInnsynId<Dokumentbeskrivelse.Dokumentbeskrivelse>,
    ): Responses.OkResponse<Dokumentbeskrivelse.Dokumentbeskrivelse>;
  }
}

namespace Votering {
  @route("/votering")
  @tag("Votering")
  interface VoteringRoutes extends Routable<Votering> {}
}
