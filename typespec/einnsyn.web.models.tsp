import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./einnsyn.arkiv.models.tsp";
import "./einnsyn.web.operations.tsp";

using TypeSpec.OpenAPI;

namespace EInnsyn;

namespace Bruker {
  /**
   * eInnsyn bruker
   */
  @extension("x-idPrefix", "bru")
  model Bruker extends Base.Base {
    @visibility("read") entity: "Bruker";
    @format("email") email: string;
    @visibility("read") active: boolean;
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
    @visibility("read") entity: "Innsynskrav";
    innsynskravBestilling?: ExpandableField<InnsynskravBestilling.InnsynskravBestilling>;
    journalpost: ExpandableField<Journalpost.Journalpost>;
    enhet?: ExpandableField<Enhet.Enhet>;
    @visibility("read") @format("email") email?: string;
    sent?: utcDateTime;
  }
}

namespace InnsynskravBestilling {
  /**
   * Innsynskrav
   */
  @extension("x-idPrefix", "ik")
  model InnsynskravBestilling extends Base.Base {
    @visibility("read") entity: "Innsynskrav";
    @format("email") email: string;
    innsynskrav: ExpandableField<Innsynskrav.Innsynskrav>[];
    @visibility("read") verified?: boolean;
    @visibility("read") bruker?: ExpandableField<Bruker.Bruker>;
    language?: "nb" | "nn" | "en" | "se" = "nb";
  }
}

namespace LagretSak {
  /**
   * LagretSak
   */
  @extension("x-idPrefix", "lsak")
  model LagretSak extends Base.Base {
    @visibility("read") entity: "LagretSak";

    /**
     * The bruker that has saved this sak. This will be set to the authenticated user.
     */
    @visibility("read") bruker: ExpandableField<Bruker.Bruker>;

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
    @visibility("read") entity: "LagretSoek";
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
    @visibility("read") entity: "Tilbakemelding";
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
