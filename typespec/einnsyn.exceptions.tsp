import "@typespec/http";
import "@typespec/openapi";

using TypeSpec.Http;

namespace EInnsyn;

namespace Exceptions {
  @error
  model EInnsynException {
    type: string = "eInnsynException";
    message: string;
  }

  @error
  model AuthenticationException extends EInnsynException {
    type: "authenticationError";
  }

  @error
  model AuthorizationException extends EInnsynException {
    type: "authorizationError";
  }

  @error
  model BadRequestException extends EInnsynException {
    type: "badRequest";
  }

  @error
  model ConflictException extends EInnsynException {
    type: "conflict";
  }

  @error
  model InternalServerErrorException extends EInnsynException {
    type: "internalServerError";
  }

  @error
  model NetworkException extends EInnsynException {
    type: "networkError";
    baseUrl?: string;
  }

  @error
  model NotFoundException extends EInnsynException {
    type: "notFound";
  }

  @error
  model MethodNotAllowedException extends EInnsynException {
    type: "methodNotAllowed";
  }

  @error
  model ValidationException extends EInnsynException {
    type: "validationError";
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
