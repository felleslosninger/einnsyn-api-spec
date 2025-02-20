import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using TypeSpec.Http;

namespace EInnsyn;

namespace Exceptions {
  @error
  model EInnsynException {
    @visibility("read") type: string = "eInnsynException";
    message: string;
    status: string;
  }

  @error
  model AuthenticationException extends EInnsynException {
    @visibility("read") type: "authenticationError";
  }

  @error
  model AuthorizationException extends EInnsynException {
    @visibility("read") type: "authorizationError";
  }

  @error
  model BadRequestException extends EInnsynException {
    @visibility("read") type: "badRequest";
  }

  @error
  model ConflictException extends EInnsynException {
    @visibility("read") type: "conflict";
  }

  @error
  model InternalServerErrorException extends EInnsynException {
    @visibility("read") type: "internalServerError";
  }

  @error
  model NetworkException extends EInnsynException {
    @visibility("read") type: "networkError";
    baseUrl?: string;
  }

  @error
  model NotFoundException extends EInnsynException {
    @visibility("read") type: "notFound";
  }

  @error
  model ValidationException extends EInnsynException {
    @visibility("read") type: "validationError";
    fieldError: {
      fieldName: string;
      value?: string;
      message?: string;
    }[];
  }

  @error
  model ErrorResponse {
    @statusCode _: 400;
    @body body: EInnsynException;
  }
}
