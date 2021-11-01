class MyClass {
  final String value;
  const MyClass.named(this.value);
}

typedef MyClassTypedef = MyClass;

// Causes error
const MyClassTypedef test = MyClassTypedef.named("value");

main(List<String> args) {
  // causes no error
  final _test = MyClassTypedef.named("value");
}

/**
Crash when compiling file:///home/omni/repos/playground/dart_playground/bin/experiments/ast_error.dart,
at character offset null:
Null check operator used on a null value
#0      TreeNode.replaceWith (package:kernel/ast.dart:188:11)
#1      BodyBuilder._unaliasTypeAliasedConstructorInvocations (package:front_end/src/fasta/kernel/body_builder.dart:1384:18)
#2      BodyBuilder.performBacklogComputations (package:front_end/src/fasta/kernel/body_builder.dart:873:5)
#3      BodyBuilder.finishFields (package:front_end/src/fasta/kernel/body_builder.dart:861:5)
#4      DietListener._parseFields (package:front_end/src/fasta/source/diet_listener.dart:1011:17)
#5      DietListener.buildFields (package:front_end/src/fasta/source/diet_listener.dart:833:5)
#6      DietListener.endTopLevelFields (package:front_end/src/fasta/source/diet_listener.dart:377:5)
#7      Parser.parseFields (package:_fe_analyzer_shared/src/parser/parser_impl.dart:2948:18)
#8      Parser.parseTopLevelMemberImpl (package:_fe_analyzer_shared/src/parser/parser_impl.dart:2839:12)
#9      Parser.parseTopLevelDeclarationImpl (package:_fe_analyzer_shared/src/parser/parser_impl.dart:509:16)
#10     Parser.parseUnit (package:_fe_analyzer_shared/src/parser/parser_impl.dart:377:15)
#11     SourceLoader.buildBody (package:front_end/src/fasta/source/source_loader.dart:499:14)
<asynchronous suspension>
#12     Loader.buildBodies (package:front_end/src/fasta/loader.dart:296:9)
<asynchronous suspension>
#13     KernelTarget.buildComponent.<anonymous closure> (package:front_end/src/fasta/kernel/kernel_target.dart:371:7)
<asynchronous suspension>
#14     withCrashReporting (package:front_end/src/fasta/crash.dart:122:12)
<asynchronous suspension>
#15     generateKernelInternal.<anonymous closure> (package:front_end/src/kernel_generator_impl.dart:162:19)
<asynchronous suspension>
#16     withCrashReporting (package:front_end/src/fasta/crash.dart:122:12)
<asynchronous suspension>
#17     generateKernel.<anonymous closure> (package:front_end/src/kernel_generator_impl.dart:50:12)
<asynchronous suspension>
#18     generateKernel (package:front_end/src/kernel_generator_impl.dart:49:10)
<asynchronous suspension>
#19     kernelForModule (package:front_end/src/api_prototype/kernel_generator.dart:97:11)
<asynchronous suspension>
#20     SingleShotCompilerWrapper.compileInternal (file:///b/s/w/ir/cache/builder/sdk/pkg/vm/bin/kernel_service.dart:398:11)
<asynchronous suspension>
#21     Compiler.compile.<anonymous closure> (file:///b/s/w/ir/cache/builder/sdk/pkg/vm/bin/kernel_service.dart:216:45)
<asynchronous suspension>
#22     _processLoadRequest (file:///b/s/w/ir/cache/builder/sdk/pkg/vm/bin/kernel_service.dart:886:37)
<asynchronous suspension>

#0      TreeNode.replaceWith (package:kernel/ast.dart:188:11)
#1      BodyBuilder._unaliasTypeAliasedConstructorInvocations (package:front_end/src/fasta/kernel/body_builder.dart:1384:18)
#2      BodyBuilder.performBacklogComputations (package:front_end/src/fasta/kernel/body_builder.dart:873:5)
#3      BodyBuilder.finishFields (package:front_end/src/fasta/kernel/body_builder.dart:861:5)
#4      DietListener._parseFields (package:front_end/src/fasta/source/diet_listener.dart:1011:17)
#5      DietListener.buildFields (package:front_end/src/fasta/source/diet_listener.dart:833:5)
#6      DietListener.endTopLevelFields (package:front_end/src/fasta/source/diet_listener.dart:377:5)
#7      Parser.parseFields (package:_fe_analyzer_shared/src/parser/parser_impl.dart:2948:18)
#8      Parser.parseTopLevelMemberImpl (package:_fe_analyzer_shared/src/parser/parser_impl.dart:2839:12)
#9      Parser.parseTopLevelDeclarationImpl (package:_fe_analyzer_shared/src/parser/parser_impl.dart:509:16)
#10     Parser.parseUnit (package:_fe_analyzer_shared/src/parser/parser_impl.dart:377:15)
#11     SourceLoader.buildBody (package:front_end/src/fasta/source/source_loader.dart:499:14)
<asynchronous suspension>
#12     Loader.buildBodies (package:front_end/src/fasta/loader.dart:296:9)
<asynchronous suspension>
#13     KernelTarget.buildComponent.<anonymous closure> (package:front_end/src/fasta/kernel/kernel_target.dart:371:7)
<asynchronous suspension>
#14     withCrashReporting (package:front_end/src/fasta/crash.dart:122:12)
<asynchronous suspension>
#15     generateKernelInternal.<anonymous closure> (package:front_end/src/kernel_generator_impl.dart:162:19)
<asynchronous suspension>
#16     withCrashReporting (package:front_end/src/fasta/crash.dart:122:12)
<asynchronous suspension>
#17     generateKernel.<anonymous closure> (package:front_end/src/kernel_generator_impl.dart:50:12)
<asynchronous suspension>
#18     generateKernel (package:front_end/src/kernel_generator_impl.dart:49:10)
<asynchronous suspension>
#19     kernelForModule (package:front_end/src/api_prototype/kernel_generator.dart:97:11)
<asynchronous suspension>
#20     SingleShotCompilerWrapper.compileInternal (file:///b/s/w/ir/cache/builder/sdk/pkg/vm/bin/kernel_service.dart:398:11)
<asynchronous suspension>
#21     Compiler.compile.<anonymous closure> (file:///b/s/w/ir/cache/builder/sdk/pkg/vm/bin/kernel_service.dart:216:45)
<asynchronous suspension>
#22     _processLoadRequest (file:///b/s/w/ir/cache/builder/sdk/pkg/vm/bin/kernel_service.dart:886:37)
<asynchronous suspension>

Exited (252)

 */