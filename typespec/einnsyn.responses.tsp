import "@typespec/http";
import "@typespec/openapi";
import "./einnsyn.arkiv.models.tsp";

using TypeSpec.Http;

namespace EInnsyn;

namespace Responses {
  model PaginatedList<T extends Base.Base> {
    /**
     * A paginated list of items.
     */
    items: ExpandableField<T>[];

    /**
     * The URL for the next page of items.
     */
    next?: url;

    /**
     * The URL for the previous page of items.
     */
    previous?: url;

    /**
     * The total number of matching items. Only returned by the search endpoint.
     */
    total?: {
      /**
       * The number of matching items. A lower bound when `capped` is true.
       */
      value: int64;

      /**
       * True if counting stopped at `value`, meaning there are at least `value` matching items.
       */
      capped: boolean;
    };
  }

  model ListResponse<T extends Base.Base> {
    @statusCode _: 200;
    @body body: PaginatedList<T>;
  }

  model OkResponse<T extends Base.Base> {
    @statusCode _: 200;
    @body body: T;
  }

  model AddResponse<T extends Base.Base> {
    @statusCode _: 201;
    @body body: T;
  }
}
