; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.field_t = type { i32**, i32, i32 }

@main_field = dso_local global %struct.field_t zeroinitializer, align 8
@tmp_field = dso_local global %struct.field_t zeroinitializer, align 8

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @main(i32 noundef %0, i8** noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  call void @field_init(%struct.field_t* noundef @main_field)
  call void @field_init(%struct.field_t* noundef @tmp_field)
  %6 = load i32, i32* %4, align 4
  %7 = load i8**, i8*** %5, align 8
  call void @gl_init(i32 noundef %6, i8** noundef %7)
  call void @field_delete(%struct.field_t* noundef @main_field)
  call void @field_delete(%struct.field_t* noundef @tmp_field)
  ret i32 0
}

declare void @field_init(%struct.field_t* noundef) #1

declare void @gl_init(i32 noundef, i8** noundef) #1

declare void @field_delete(%struct.field_t* noundef) #1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @display() #0 {
  call void @glClear(i32 noundef 16640)
  call void @glLoadIdentity()
  call void @glBegin(i32 noundef 7)
  call void @draw_field(%struct.field_t* noundef @main_field)
  call void @glEnd()
  call void @glFlush()
  call void @glutSwapBuffers()
  ret void
}

declare void @glClear(i32 noundef) #1

declare void @glLoadIdentity() #1

declare void @glBegin(i32 noundef) #1

declare void @draw_field(%struct.field_t* noundef) #1

declare void @glEnd() #1

declare void @glFlush() #1

declare void @glutSwapBuffers() #1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @update() #0 {
  call void @make_next_gen(%struct.field_t* noundef @main_field, %struct.field_t* noundef @tmp_field)
  call void @swap(%struct.field_t* noundef @main_field, %struct.field_t* noundef @tmp_field)
  call void @glutPostRedisplay()
  call void @glutTimerFunc(i32 noundef 33, void (i32)* noundef bitcast (void ()* @update to void (i32)*), i32 noundef 0)
  ret void
}

declare void @make_next_gen(%struct.field_t* noundef, %struct.field_t* noundef) #1

declare void @swap(%struct.field_t* noundef, %struct.field_t* noundef) #1

declare void @glutPostRedisplay() #1

declare void @glutTimerFunc(i32 noundef, void (i32)* noundef, i32 noundef) #1

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
