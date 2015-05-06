/**
 Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License").
 You may not use this file except in compliance with the License.
 A copy of the License is located at

 http://aws.amazon.com/apache2.0

 or in the "license" file accompanying this file. This file is distributed
 on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 express or implied. See the License for the specific language governing
 permissions and limitations under the License.
 */

#import "AWSLambdaModel.h"
#import "AWSCategory.h"

NSString *const AWSLambdaErrorDomain = @"com.amazonaws.AWSLambdaErrorDomain";

@implementation AWSLambdaAddPermissionRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"action" : @"Action",
             @"functionName" : @"FunctionName",
             @"principal" : @"Principal",
             @"sourceAccount" : @"SourceAccount",
             @"sourceArn" : @"SourceArn",
             @"statementId" : @"StatementId",
             };
}

@end

@implementation AWSLambdaAddPermissionResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"statement" : @"Statement",
             };
}

@end

@implementation AWSLambdaCreateEventSourceMappingRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"batchSize" : @"BatchSize",
             @"enabled" : @"Enabled",
             @"eventSourceArn" : @"EventSourceArn",
             @"functionName" : @"FunctionName",
             @"startingPosition" : @"StartingPosition",
             };
}

+ (NSValueTransformer *)startingPositionJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSNumber *(NSString *value) {
        if ([value isEqualToString:@"TRIM_HORIZON"]) {
            return @(AWSLambdaEventSourcePositionTrimHorizon);
        }
        if ([value isEqualToString:@"LATEST"]) {
            return @(AWSLambdaEventSourcePositionLatest);
        }
        return @(AWSLambdaEventSourcePositionUnknown);
    } reverseBlock:^NSString *(NSNumber *value) {
        switch ([value integerValue]) {
            case AWSLambdaEventSourcePositionTrimHorizon:
                return @"TRIM_HORIZON";
            case AWSLambdaEventSourcePositionLatest:
                return @"LATEST";
            case AWSLambdaEventSourcePositionUnknown:
            default:
                return nil;
        }
    }];
}

@end

@implementation AWSLambdaCreateFunctionRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"code" : @"Code",
             @"detail" : @"Description",
             @"functionName" : @"FunctionName",
             @"handler" : @"Handler",
             @"memorySize" : @"MemorySize",
             @"role" : @"Role",
             @"runtime" : @"Runtime",
             @"timeout" : @"Timeout",
             };
}

+ (NSValueTransformer *)codeJSONTransformer {
	return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[AWSLambdaFunctionCode class]];
}

+ (NSValueTransformer *)runtimeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSNumber *(NSString *value) {
        if ([value isEqualToString:@"nodejs"]) {
            return @(AWSLambdaRuntimeNodejs);
        }
        if ([value isEqualToString:@"jvm"]) {
            return @(AWSLambdaRuntimeJvm);
        }
        if ([value isEqualToString:@"python"]) {
            return @(AWSLambdaRuntimePython);
        }
        return @(AWSLambdaRuntimeUnknown);
    } reverseBlock:^NSString *(NSNumber *value) {
        switch ([value integerValue]) {
            case AWSLambdaRuntimeNodejs:
                return @"nodejs";
            case AWSLambdaRuntimeJvm:
                return @"jvm";
            case AWSLambdaRuntimePython:
                return @"python";
            case AWSLambdaRuntimeUnknown:
            default:
                return nil;
        }
    }];
}

@end

@implementation AWSLambdaDeleteEventSourceMappingRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"UUID" : @"UUID",
             };
}

@end

@implementation AWSLambdaDeleteFunctionRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"functionName" : @"FunctionName",
             };
}

@end

@implementation AWSLambdaEventSourceMappingConfiguration

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"batchSize" : @"BatchSize",
             @"eventSourceArn" : @"EventSourceArn",
             @"functionArn" : @"FunctionArn",
             @"lastModified" : @"LastModified",
             @"lastProcessingResult" : @"LastProcessingResult",
             @"state" : @"State",
             @"stateTransitionReason" : @"StateTransitionReason",
             @"UUID" : @"UUID",
             };
}

+ (NSValueTransformer *)lastModifiedJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *str) {
        return [NSDate aws_dateFromString:str];
    } reverseBlock:^id(NSDate *date) {
        return [date aws_stringValue:AWSDateISO8601DateFormat1];
    }];
}

@end

@implementation AWSLambdaFunctionCode

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"zipFile" : @"ZipFile",
             };
}

@end

@implementation AWSLambdaFunctionCodeLocation

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"location" : @"Location",
             @"repositoryType" : @"RepositoryType",
             };
}

@end

@implementation AWSLambdaFunctionConfiguration

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"codeSize" : @"CodeSize",
             @"detail" : @"Description",
             @"functionArn" : @"FunctionArn",
             @"functionName" : @"FunctionName",
             @"handler" : @"Handler",
             @"lastModified" : @"LastModified",
             @"memorySize" : @"MemorySize",
             @"role" : @"Role",
             @"runtime" : @"Runtime",
             @"timeout" : @"Timeout",
             };
}

+ (NSValueTransformer *)runtimeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSNumber *(NSString *value) {
        if ([value isEqualToString:@"nodejs"]) {
            return @(AWSLambdaRuntimeNodejs);
        }
        if ([value isEqualToString:@"jvm"]) {
            return @(AWSLambdaRuntimeJvm);
        }
        if ([value isEqualToString:@"python"]) {
            return @(AWSLambdaRuntimePython);
        }
        return @(AWSLambdaRuntimeUnknown);
    } reverseBlock:^NSString *(NSNumber *value) {
        switch ([value integerValue]) {
            case AWSLambdaRuntimeNodejs:
                return @"nodejs";
            case AWSLambdaRuntimeJvm:
                return @"jvm";
            case AWSLambdaRuntimePython:
                return @"python";
            case AWSLambdaRuntimeUnknown:
            default:
                return nil;
        }
    }];
}

@end

@implementation AWSLambdaGetEventSourceMappingRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"UUID" : @"UUID",
             };
}

@end

@implementation AWSLambdaGetFunctionConfigurationRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"functionName" : @"FunctionName",
             };
}

@end

@implementation AWSLambdaGetFunctionRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"functionName" : @"FunctionName",
             };
}

@end

@implementation AWSLambdaGetFunctionResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"code" : @"Code",
             @"configuration" : @"Configuration",
             };
}

+ (NSValueTransformer *)codeJSONTransformer {
	return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[AWSLambdaFunctionCodeLocation class]];
}

+ (NSValueTransformer *)configurationJSONTransformer {
	return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[AWSLambdaFunctionConfiguration class]];
}

@end

@implementation AWSLambdaGetPolicyRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"functionName" : @"FunctionName",
             };
}

@end

@implementation AWSLambdaGetPolicyResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"policy" : @"Policy",
             };
}

@end

@implementation AWSLambdaInvocationRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"clientContext" : @"ClientContext",
             @"functionName" : @"FunctionName",
             @"invocationType" : @"InvocationType",
             @"logType" : @"LogType",
             @"payload" : @"Payload",
             };
}

+ (NSValueTransformer *)invocationTypeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSNumber *(NSString *value) {
        if ([value isEqualToString:@"Event"]) {
            return @(AWSLambdaInvocationTypeEvent);
        }
        if ([value isEqualToString:@"RequestResponse"]) {
            return @(AWSLambdaInvocationTypeRequestResponse);
        }
        if ([value isEqualToString:@"DryRun"]) {
            return @(AWSLambdaInvocationTypeDryRun);
        }
        return @(AWSLambdaInvocationTypeUnknown);
    } reverseBlock:^NSString *(NSNumber *value) {
        switch ([value integerValue]) {
            case AWSLambdaInvocationTypeEvent:
                return @"Event";
            case AWSLambdaInvocationTypeRequestResponse:
                return @"RequestResponse";
            case AWSLambdaInvocationTypeDryRun:
                return @"DryRun";
            case AWSLambdaInvocationTypeUnknown:
            default:
                return nil;
        }
    }];
}

+ (NSValueTransformer *)logTypeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSNumber *(NSString *value) {
        if ([value isEqualToString:@"None"]) {
            return @(AWSLambdaLogTypeNone);
        }
        if ([value isEqualToString:@"Tail"]) {
            return @(AWSLambdaLogTypeTail);
        }
        return @(AWSLambdaLogTypeUnknown);
    } reverseBlock:^NSString *(NSNumber *value) {
        switch ([value integerValue]) {
            case AWSLambdaLogTypeNone:
                return @"None";
            case AWSLambdaLogTypeTail:
                return @"Tail";
            case AWSLambdaLogTypeUnknown:
            default:
                return nil;
        }
    }];
}

@end

@implementation AWSLambdaInvocationResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"functionError" : @"FunctionError",
             @"logResult" : @"LogResult",
             @"payload" : @"Payload",
             @"statusCode" : @"StatusCode",
             };
}

@end

@implementation AWSLambdaInvokeAsyncRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"functionName" : @"FunctionName",
             @"invokeArgs" : @"InvokeArgs",
             };
}

@end

@implementation AWSLambdaInvokeAsyncResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"status" : @"Status",
             };
}

@end

@implementation AWSLambdaListEventSourceMappingsRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"eventSourceArn" : @"EventSourceArn",
             @"functionName" : @"FunctionName",
             @"marker" : @"Marker",
             @"maxItems" : @"MaxItems",
             };
}

@end

@implementation AWSLambdaListEventSourceMappingsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"eventSourceMappings" : @"EventSourceMappings",
             @"nextMarker" : @"NextMarker",
             };
}

+ (NSValueTransformer *)eventSourceMappingsJSONTransformer {
	return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[AWSLambdaEventSourceMappingConfiguration class]];
}

@end

@implementation AWSLambdaListFunctionsRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"marker" : @"Marker",
             @"maxItems" : @"MaxItems",
             };
}

@end

@implementation AWSLambdaListFunctionsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"functions" : @"Functions",
             @"nextMarker" : @"NextMarker",
             };
}

+ (NSValueTransformer *)functionsJSONTransformer {
	return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[AWSLambdaFunctionConfiguration class]];
}

@end

@implementation AWSLambdaRemovePermissionRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"functionName" : @"FunctionName",
             @"statementId" : @"StatementId",
             };
}

@end

@implementation AWSLambdaUpdateEventSourceMappingRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"batchSize" : @"BatchSize",
             @"enabled" : @"Enabled",
             @"functionName" : @"FunctionName",
             @"UUID" : @"UUID",
             };
}

@end

@implementation AWSLambdaUpdateFunctionCodeRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"functionName" : @"FunctionName",
             @"zipFile" : @"ZipFile",
             };
}

@end

@implementation AWSLambdaUpdateFunctionConfigurationRequest

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
             @"detail" : @"Description",
             @"functionName" : @"FunctionName",
             @"handler" : @"Handler",
             @"memorySize" : @"MemorySize",
             @"role" : @"Role",
             @"timeout" : @"Timeout",
             };
}

@end
