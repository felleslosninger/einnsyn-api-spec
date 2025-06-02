import "@typespec/http";
import "@typespec/openapi";
import "./einnsyn.arkiv.models.tsp";
import "./einnsyn.web.operations.tsp";

using TypeSpec.OpenAPI;

namespace EInnsyn;

namespace ApiKey {
  /**
   * An API key used to authenticate requests to the eInnsyn API.
   */
  @extension("x-idPrefix", "key")
  model ApiKey extends Base.Base {
    @visibility(Lifecycle.Read) entity: "ApiKey";

    /**
     * A name for the API key. This can be used to identify the key, in case you have multiple keys for multiple systems.
     */
    name?: string;

    /**
     * The API key used to authenticate requests. This will only be shown once, and we will only store a hashed version.
     */
    @visibility(Lifecycle.Read) secretKey: string;

    /**
     * An Enhet that requests using this key will be associated with.
     */
    enhet?: ExpandableField<Enhet.Enhet>;

    /**
     * A Bruker that requests using this key will be associated with.
     */
    bruker?: ExpandableField<Bruker.Bruker>;

    /**
     * Specifies the expiration date of the API key. If this is set, the key will not be usable after this date.
     */
    expiresAt?: utcDateTime;
  }
}

namespace Bruker {
  /**
   * eInnsyn bruker
   */
  @extension("x-idPrefix", "bru")
  model Bruker extends Base.Base {
    @visibility(Lifecycle.Read) entity: "Bruker";
    @format("email") email: string;
    @visibility(Lifecycle.Read) active: boolean;
    @format("password") password: string;
    language?: "nb" | "nn" | "en" | "se" = "nb";
  }
}

namespace Innsynskrav {
  /**
   * Innsynskrav
   */
  @extension("x-idPrefix", "ikd")
  model Innsynskrav extends Base.Base {
    @visibility(Lifecycle.Read) entity: "Innsynskrav";
    innsynskravBestilling?: ExpandableField<InnsynskravBestilling.InnsynskravBestilling>;
    journalpost: ExpandableField<Journalpost.Journalpost>;
    enhet?: ExpandableField<Enhet.Enhet>;
    @visibility(Lifecycle.Read) @format("email") email?: string;
    sent?: utcDateTime;
  }
}

namespace InnsynskravBestilling {
  /**
   * Innsynskrav
   */
  @extension("x-idPrefix", "ik")
  model InnsynskravBestilling extends Base.Base {
    @visibility(Lifecycle.Read) entity: "InnsynskravBestilling";
    @format("email") email: string;
    innsynskrav: ExpandableField<Innsynskrav.Innsynskrav>[];
    @visibility(Lifecycle.Read) verified?: boolean;
    @visibility(Lifecycle.Read) bruker?: ExpandableField<Bruker.Bruker>;
    language?: "nb" | "nn" | "en" | "se" = "nb";
  }
}

namespace LagretSak {
  /**
   * LagretSak
   */
  @extension("x-idPrefix", "lsak")
  model LagretSak extends Base.Base {
    @visibility(Lifecycle.Read) entity: "LagretSak";

    /**
     * The bruker that has saved this sak. This will be set to the authenticated user.
     */
    @visibility(Lifecycle.Read) bruker: ExpandableField<Bruker.Bruker>;

    /**
     * The saksmappe that has been saved.
     */
    saksmappe?: ExpandableField<Saksmappe.Saksmappe>;

    /**
     * The moetemappe that has been saved.
     */
    moetemappe?: ExpandableField<Moetemappe.Moetemappe>;

    /**
     * Specifies whether the user wants to receive notifications about this sak.
     */
    subscribe?: boolean;
  }
}

namespace LagretSoek {
  /**
   * LagretSoek
   */
  @extension("x-idPrefix", "lsoek")
  model LagretSoek extends Base.Base {
    @visibility(Lifecycle.Read) entity: "LagretSoek";
    bruker?: ExpandableField<Bruker.Bruker>;
    label: string;
    subscribe?: boolean;
    searchParameters?: Search.SearchParameters;
    legacyQuery?: string;
  }
}

namespace Tilbakemelding {
  /**
   * Tilbakemelding
   */
  @extension("x-idPrefix", "tbm")
  model Tilbakemelding extends Base.Base {
    @visibility(Lifecycle.Read) entity: "Tilbakemelding";
    messageFromUser?: string;
    path?: string;
    referer?: string;
    userAgent?: string;
    screenHeight?: integer;
    screenWidth?: integer;
    docHeight?: integer;
    docWidth?: integer;
    winHeight?: integer;
    winWidth?: integer;
    scrollX?: integer;
    scrollY?: integer;
    userSatisfied?: boolean;
    handledByAdmin?: boolean;
    adminComment?: string;
  }
}
