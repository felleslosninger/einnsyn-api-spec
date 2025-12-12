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
   * Represents a request for access to a specific registry entry (Journalpost).
   */
  @extension("x-idPrefix", "ikd")
  model Innsynskrav extends Base.Base {
    @visibility(Lifecycle.Read) entity: "Innsynskrav";

    /** The order containing this access request. */
    innsynskravBestilling?: ExpandableField<InnsynskravBestilling.InnsynskravBestilling>;

    /** The registry entry being requested. */
    journalpost: ExpandableField<Journalpost.Journalpost>;

    /** The public authority responsible for handling the request. */
    enhet?: ExpandableField<Enhet.Enhet>;

    /** The email address of the requester. */
    @visibility(Lifecycle.Read) @format("email") email?: string;

    /** The timestamp when the request was sent to the public authority. */
    sent?: utcDateTime;
  }
}

namespace InnsynskravBestilling {
  /**
   * Represents an order containing one or more access requests (Innsynskrav).
   */
  @extension("x-idPrefix", "ik")
  model InnsynskravBestilling extends Base.Base {
    @visibility(Lifecycle.Read) entity: "InnsynskravBestilling";

    /** The email address of the person who placed the order. */
    @format("email") email: string;

    /** The list of individual access requests in this order. */
    innsynskrav: ExpandableField<Innsynskrav.Innsynskrav>[];

    /** Indicates whether the email address has been verified. */
    @visibility(Lifecycle.Read) verified?: boolean;

    /** The user who placed the order, if authenticated. */
    @visibility(Lifecycle.Read) bruker?: ExpandableField<Bruker.Bruker>;

    /** The preferred language for communication. */
    language?: "nb" | "nn" | "en" | "se" = "nb";
  }
}

namespace LagretSak {
  /**
   * Represents a case file (Saksmappe or Moetemappe) that a user has saved for quick access.
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
   * Represents a search query saved by a user.
   */
  @extension("x-idPrefix", "lsoek")
  model LagretSoek extends Base.Base {
    @visibility(Lifecycle.Read) entity: "LagretSoek";

    /** The user who saved the search. */
    bruker?: ExpandableField<Bruker.Bruker>;

    /** A user-defined label for the saved search. */
    label: string;

    /** Specifies whether the user wants to receive notifications for new results matching this search. */
    subscribe?: boolean;

    /** The parameters of the saved search. */
    searchParameters?: Search.SearchParameters;

    /** A legacy field for storing the raw query string. */
    legacyQuery?: string;
  }
}

namespace Tilbakemelding {
  /**
   * Represents user feedback submitted through the application.
   */
  @extension("x-idPrefix", "tbm")
  model Tilbakemelding extends Base.Base {
    @visibility(Lifecycle.Read) entity: "Tilbakemelding";

    /** The feedback message from the user. */
    messageFromUser?: string;

    /** The path of the page where the feedback was submitted. */
    path?: string;

    /** The referer URL. */
    referer?: string;

    /** The user agent string of the user's browser. */
    userAgent?: string;

    /** The screen height of the user's device. */
    screenHeight?: integer;

    /** The screen width of the user's device. */
    screenWidth?: integer;

    /** The document height of the page. */
    docHeight?: integer;

    /** The document width of the page. */
    docWidth?: integer;

    /** The window height of the browser. */
    winHeight?: integer;

    /** The window width of the browser. */
    winWidth?: integer;

    /** The horizontal scroll position. */
    scrollX?: integer;

    /** The vertical scroll position. */
    scrollY?: integer;

    /** Indicates whether the user was satisfied. */
    userSatisfied?: boolean;

    /** Indicates whether the feedback has been handled by an administrator. */
    handledByAdmin?: boolean;

    /** A comment from the administrator who handled the feedback. */
    adminComment?: string;
  }
}
