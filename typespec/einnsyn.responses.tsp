import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./einnsyn.arkiv.models.tsp";

using TypeSpec.Http;

namespace EInnsyn;

namespace Responses {
  model ListResponseBody<T extends Base.Base> {
    /**
     * A paginated list of items.
     */
    items: Array<T>;

    /**
     * The URL for the next page of items.
     */
    next?: url;

    /**
     * The URL for the previous page of items.
     */
    previous?: url;
  }

  model ErrorResponseBody {
    status: string;
    message: string;
  }

  model ValidationErrorResponseBody extends ErrorResponseBody {
    fieldError: {
      fieldName: string;
      value?: string;
      message?: string;
    }[];
  }

  /**
   * Result list
   */
  model ListResponse<T extends Base.Base> {
    @statusCode _: 200;
    @body body: ListResponseBody<T>;
  }

  model OkResponse<T extends Base.Base> {
    @statusCode _: 200;
    @body body: T;
  }

  model AddResponse<T extends Base.Base> {
    @statusCode _: 201;
    @body body: T;
  }

  @error
  model ErrorResponse {
    @statusCode _: 400;
    @body body: ErrorResponseBody;
  }
}
