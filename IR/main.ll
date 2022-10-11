; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.field_t = type { [800 x [800 x i8]], i32, i32 }

@main_field = dso_local global %struct.field_t zeroinitializer, align 4
@tmp_field = dso_local global %struct.field_t zeroinitializer, align 4

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void (...) @graph_init()
  call void @field_init(%struct.field_t* noundef @main_field)
  call void @field_init(%struct.field_t* noundef @tmp_field)
  br label %2

2:                                                ; preds = %4, %0
  %3 = call zeroext i1 (...) @is_open_window()
  br i1 %3, label %4, label %5

4:                                                ; preds = %2
  call void @window_clear(i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0)
  call void @make_next_gen(%struct.field_t* noundef @main_field, %struct.field_t* noundef @tmp_field)
  call void @draw_field(%struct.field_t* noundef @main_field)
  call void @swap(%struct.field_t* noundef @main_field, %struct.field_t* noundef @tmp_field)
  call void (...) @flush()
  br label %2, !llvm.loop !6

5:                                                ; preds = %2
  ret i32 0
}

declare void @graph_init(...) #1

declare void @field_init(%struct.field_t* noundef) #1

declare zeroext i1 @is_open_window(...) #1

declare void @window_clear(i8 noundef zeroext, i8 noundef zeroext, i8 noundef zeroext) #1

declare void @make_next_gen(%struct.field_t* noundef, %struct.field_t* noundef) #1

declare void @draw_field(%struct.field_t* noundef) #1

declare void @swap(%struct.field_t* noundef, %struct.field_t* noundef) #1

declare void @flush(...) #1

attributes #0 = { noinline nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 14.0.6"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
