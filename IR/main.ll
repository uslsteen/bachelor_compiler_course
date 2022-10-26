; ModuleID = 'main.c'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@main_field = dso_local local_unnamed_addr global [800 x [800 x i8]] zeroinitializer, align 16
@tmp_field = dso_local local_unnamed_addr global [800 x [800 x i8]] zeroinitializer, align 16

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @field_init() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %0, %4
  %2 = phi i64 [ 0, %0 ], [ %5, %4 ]
  br label %7

3:                                                ; preds = %4
  ret void

4:                                                ; preds = %7
  %5 = add nuw nsw i64 %2, 1
  %6 = icmp eq i64 %5, 800
  br i1 %6, label %3, label %1, !llvm.loop !5

7:                                                ; preds = %1, %7
  %8 = phi i64 [ 0, %1 ], [ %12, %7 ]
  %9 = tail call i32 (...) @get_random_val() #6
  %10 = trunc i32 %9 to i8
  %11 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %8, i64 %2
  store i8 %10, i8* %11, align 1, !tbaa !7
  %12 = add nuw nsw i64 %8, 1
  %13 = icmp eq i64 %12, 800
  br i1 %13, label %4, label %7, !llvm.loop !10
}

declare i32 @get_random_val(...) local_unnamed_addr #1

; Function Attrs: mustprogress nofree norecurse nosync nounwind readonly sspstrong uwtable willreturn
define dso_local i32 @get_cell(i64 %0, i64 %1) local_unnamed_addr #2 {
  %3 = add i64 %0, 800
  %4 = urem i64 %3, 800
  %5 = add i64 %1, 800
  %6 = urem i64 %5, 800
  %7 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %6, i64 %4
  %8 = load i8, i8* %7, align 1, !tbaa !7
  %9 = zext i8 %8 to i32
  ret i32 %9
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind sspstrong uwtable willreturn writeonly
define dso_local void @set_cell(i64 %0, i64 %1, i32 noundef %2) local_unnamed_addr #3 {
  %4 = trunc i32 %2 to i8
  %5 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @tmp_field, i64 0, i64 %1, i64 %0
  store i8 %4, i8* %5, align 1, !tbaa !7
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind readonly sspstrong uwtable
define dso_local i32 @get_neighbours_num(i64 %0, i64 %1) local_unnamed_addr #4 {
  %3 = add i64 %0, 800
  %4 = add i64 %1, 800
  %5 = add i64 %0, 799
  %6 = urem i64 %5, 800
  %7 = add i64 %1, 799
  %8 = urem i64 %7, 800
  %9 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %8, i64 %6
  %10 = load i8, i8* %9, align 1, !tbaa !7
  %11 = zext i8 %10 to i32
  %12 = urem i64 %4, 800
  %13 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %12, i64 %6
  %14 = load i8, i8* %13, align 1, !tbaa !7
  %15 = zext i8 %14 to i32
  %16 = add nuw nsw i32 %11, %15
  %17 = add i64 %1, 801
  %18 = urem i64 %17, 800
  %19 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %18, i64 %6
  %20 = load i8, i8* %19, align 1, !tbaa !7
  %21 = zext i8 %20 to i32
  %22 = add nuw nsw i32 %16, %21
  %23 = urem i64 %3, 800
  %24 = add i64 %1, 799
  %25 = urem i64 %24, 800
  %26 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %25, i64 %23
  %27 = load i8, i8* %26, align 1, !tbaa !7
  %28 = zext i8 %27 to i32
  %29 = add nuw nsw i32 %22, %28
  %30 = add i64 %1, 801
  %31 = urem i64 %30, 800
  %32 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %31, i64 %23
  %33 = load i8, i8* %32, align 1, !tbaa !7
  %34 = zext i8 %33 to i32
  %35 = add nuw nsw i32 %29, %34
  %36 = add i64 %0, 801
  %37 = urem i64 %36, 800
  %38 = add i64 %1, 799
  %39 = urem i64 %38, 800
  %40 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %39, i64 %37
  %41 = load i8, i8* %40, align 1, !tbaa !7
  %42 = zext i8 %41 to i32
  %43 = add nuw nsw i32 %35, %42
  %44 = urem i64 %4, 800
  %45 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %44, i64 %37
  %46 = load i8, i8* %45, align 1, !tbaa !7
  %47 = zext i8 %46 to i32
  %48 = add nuw nsw i32 %43, %47
  %49 = add i64 %1, 801
  %50 = urem i64 %49, 800
  %51 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %50, i64 %37
  %52 = load i8, i8* %51, align 1, !tbaa !7
  %53 = zext i8 %52 to i32
  %54 = add nuw nsw i32 %48, %53
  ret i32 %54
}

; Function Attrs: nofree norecurse nosync nounwind sspstrong uwtable
define dso_local void @make_next_gen() local_unnamed_addr #5 {
  br label %1

1:                                                ; preds = %0, %10
  %2 = phi i64 [ 0, %0 ], [ %11, %10 ]
  %3 = add nuw nsw i64 %2, 800
  %4 = add nuw nsw i64 %2, 799
  %5 = urem i64 %4, 800
  %6 = urem i64 %3, 800
  %7 = add nuw nsw i64 %2, 801
  %8 = urem i64 %7, 800
  br label %13

9:                                                ; preds = %10
  ret void

10:                                               ; preds = %13
  %11 = add nuw nsw i64 %2, 1
  %12 = icmp eq i64 %11, 800
  br i1 %12, label %9, label %1, !llvm.loop !11

13:                                               ; preds = %1, %13
  %14 = phi i64 [ 0, %1 ], [ %65, %13 ]
  %15 = trunc i64 %14 to i16
  %16 = add i16 %15, 799
  %17 = urem i16 %16, 800
  %18 = zext i16 %17 to i64
  %19 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %5, i64 %18
  %20 = load i8, i8* %19, align 1, !tbaa !7
  %21 = zext i8 %20 to i32
  %22 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %6, i64 %18
  %23 = load i8, i8* %22, align 1, !tbaa !7
  %24 = zext i8 %23 to i32
  %25 = add nuw nsw i32 %24, %21
  %26 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %8, i64 %18
  %27 = load i8, i8* %26, align 1, !tbaa !7
  %28 = zext i8 %27 to i32
  %29 = add nuw nsw i32 %25, %28
  %30 = add i16 %15, 800
  %31 = urem i16 %30, 800
  %32 = zext i16 %31 to i64
  %33 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %5, i64 %32
  %34 = load i8, i8* %33, align 1, !tbaa !7
  %35 = zext i8 %34 to i32
  %36 = add nuw nsw i32 %29, %35
  %37 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %8, i64 %32
  %38 = load i8, i8* %37, align 1, !tbaa !7
  %39 = zext i8 %38 to i32
  %40 = add nuw nsw i32 %36, %39
  %41 = add i16 %15, 801
  %42 = urem i16 %41, 800
  %43 = zext i16 %42 to i64
  %44 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %5, i64 %43
  %45 = load i8, i8* %44, align 1, !tbaa !7
  %46 = zext i8 %45 to i32
  %47 = add nuw nsw i32 %40, %46
  %48 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %6, i64 %43
  %49 = load i8, i8* %48, align 1, !tbaa !7
  %50 = zext i8 %49 to i32
  %51 = add nuw nsw i32 %47, %50
  %52 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %8, i64 %43
  %53 = load i8, i8* %52, align 1, !tbaa !7
  %54 = zext i8 %53 to i32
  %55 = add nuw nsw i32 %51, %54
  %56 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %6, i64 %32
  %57 = load i8, i8* %56, align 1, !tbaa !7
  %58 = icmp eq i8 %57, 0
  %59 = and i32 %55, -2
  %60 = icmp eq i32 %59, 2
  %61 = icmp eq i32 %55, 3
  %62 = select i1 %58, i1 %61, i1 %60
  %63 = zext i1 %62 to i8
  %64 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @tmp_field, i64 0, i64 %2, i64 %14
  store i8 %63, i8* %64, align 1, !tbaa !7
  %65 = add nuw nsw i64 %14, 1
  %66 = icmp eq i64 %65, 800
  br i1 %66, label %10, label %13, !llvm.loop !12
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local void @draw_field() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %0, %7
  %2 = phi i64 [ 0, %0 ], [ %8, %7 ]
  %3 = add nuw nsw i64 %2, 800
  %4 = urem i64 %3, 800
  %5 = trunc i64 %2 to i32
  br label %10

6:                                                ; preds = %7
  ret void

7:                                                ; preds = %22
  %8 = add nuw nsw i64 %2, 1
  %9 = icmp eq i64 %8, 800
  br i1 %9, label %6, label %1, !llvm.loop !13

10:                                               ; preds = %1, %22
  %11 = phi i64 [ 0, %1 ], [ %23, %22 ]
  %12 = trunc i64 %11 to i16
  %13 = add i16 %12, 800
  %14 = urem i16 %13, 800
  %15 = zext i16 %14 to i64
  %16 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %15, i64 %4
  %17 = load i8, i8* %16, align 1, !tbaa !7
  switch i8 %17, label %22 [
    i8 1, label %19
    i8 0, label %18
  ]

18:                                               ; preds = %10
  br label %19

19:                                               ; preds = %10, %18
  %20 = phi i8 [ 0, %18 ], [ -1, %10 ]
  %21 = trunc i64 %11 to i32
  tail call void @set_pixel(i32 noundef %5, i32 noundef %21, i8 noundef zeroext 0, i8 noundef zeroext %20, i8 noundef zeroext 0) #6
  br label %22

22:                                               ; preds = %19, %10
  %23 = add nuw nsw i64 %11, 1
  %24 = icmp eq i64 %23, 800
  br i1 %24, label %7, label %10, !llvm.loop !14
}

declare void @set_pixel(i32 noundef, i32 noundef, i8 noundef zeroext, i8 noundef zeroext, i8 noundef zeroext) local_unnamed_addr #1

; Function Attrs: nofree norecurse nosync nounwind sspstrong uwtable
define dso_local void @swap() local_unnamed_addr #5 {
  br label %1

1:                                                ; preds = %0, %4
  %2 = phi i64 [ 0, %0 ], [ %5, %4 ]
  br label %7

3:                                                ; preds = %4
  ret void

4:                                                ; preds = %7
  %5 = add nuw nsw i64 %2, 1
  %6 = icmp eq i64 %5, 800
  br i1 %6, label %3, label %1, !llvm.loop !15

7:                                                ; preds = %7, %1
  %8 = phi i64 [ 0, %1 ], [ %18, %7 ]
  %9 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %8, i64 %2
  %10 = load i8, i8* %9, align 1, !tbaa !7
  %11 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @tmp_field, i64 0, i64 %8, i64 %2
  %12 = load i8, i8* %11, align 1, !tbaa !7
  store i8 %12, i8* %9, align 1, !tbaa !7
  store i8 %10, i8* %11, align 1, !tbaa !7
  %13 = or i64 %8, 1
  %14 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %13, i64 %2
  %15 = load i8, i8* %14, align 1, !tbaa !7
  %16 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @tmp_field, i64 0, i64 %13, i64 %2
  %17 = load i8, i8* %16, align 1, !tbaa !7
  store i8 %17, i8* %14, align 1, !tbaa !7
  store i8 %15, i8* %16, align 1, !tbaa !7
  %18 = add nuw nsw i64 %8, 2
  %19 = icmp eq i64 %18, 800
  br i1 %19, label %4, label %7, !llvm.loop !16
}

; Function Attrs: nounwind sspstrong uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  tail call void (...) @graph_init() #6
  br label %1

1:                                                ; preds = %3, %0
  %2 = phi i64 [ 0, %0 ], [ %4, %3 ]
  br label %8

3:                                                ; preds = %8
  %4 = add nuw nsw i64 %2, 1
  %5 = icmp eq i64 %4, 800
  br i1 %5, label %6, label %1, !llvm.loop !5

6:                                                ; preds = %3
  %7 = tail call zeroext i1 (...) @is_open_window() #6
  br i1 %7, label %15, label %59

8:                                                ; preds = %8, %1
  %9 = phi i64 [ 0, %1 ], [ %13, %8 ]
  %10 = tail call i32 (...) @get_random_val() #6
  %11 = trunc i32 %10 to i8
  %12 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %9, i64 %2
  store i8 %11, i8* %12, align 1, !tbaa !7
  %13 = add nuw nsw i64 %9, 1
  %14 = icmp eq i64 %13, 800
  br i1 %14, label %3, label %8, !llvm.loop !10

15:                                               ; preds = %6, %57
  tail call void @window_clear(i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0) #6
  tail call void @make_next_gen()
  br label %16

16:                                               ; preds = %21, %15
  %17 = phi i64 [ 0, %15 ], [ %22, %21 ]
  %18 = add nuw nsw i64 %17, 800
  %19 = urem i64 %18, 800
  %20 = trunc i64 %17 to i32
  br label %24

21:                                               ; preds = %36
  %22 = add nuw nsw i64 %17, 1
  %23 = icmp eq i64 %22, 800
  br i1 %23, label %39, label %16, !llvm.loop !13

24:                                               ; preds = %36, %16
  %25 = phi i64 [ 0, %16 ], [ %37, %36 ]
  %26 = trunc i64 %25 to i16
  %27 = add i16 %26, 800
  %28 = urem i16 %27, 800
  %29 = zext i16 %28 to i64
  %30 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %29, i64 %19
  %31 = load i8, i8* %30, align 1, !tbaa !7
  switch i8 %31, label %36 [
    i8 1, label %33
    i8 0, label %32
  ]

32:                                               ; preds = %24
  br label %33

33:                                               ; preds = %32, %24
  %34 = phi i8 [ 0, %32 ], [ -1, %24 ]
  %35 = trunc i64 %25 to i32
  tail call void @set_pixel(i32 noundef %20, i32 noundef %35, i8 noundef zeroext 0, i8 noundef zeroext %34, i8 noundef zeroext 0) #6
  br label %36

36:                                               ; preds = %33, %24
  %37 = add nuw nsw i64 %25, 1
  %38 = icmp eq i64 %37, 800
  br i1 %38, label %21, label %24, !llvm.loop !14

39:                                               ; preds = %21, %41
  %40 = phi i64 [ %42, %41 ], [ 0, %21 ]
  br label %44

41:                                               ; preds = %44
  %42 = add nuw nsw i64 %40, 1
  %43 = icmp eq i64 %42, 800
  br i1 %43, label %57, label %39, !llvm.loop !15

44:                                               ; preds = %44, %39
  %45 = phi i64 [ 0, %39 ], [ %55, %44 ]
  %46 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %45, i64 %40
  %47 = load i8, i8* %46, align 1, !tbaa !7
  %48 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @tmp_field, i64 0, i64 %45, i64 %40
  %49 = load i8, i8* %48, align 1, !tbaa !7
  store i8 %49, i8* %46, align 1, !tbaa !7
  store i8 %47, i8* %48, align 1, !tbaa !7
  %50 = or i64 %45, 1
  %51 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @main_field, i64 0, i64 %50, i64 %40
  %52 = load i8, i8* %51, align 1, !tbaa !7
  %53 = getelementptr inbounds [800 x [800 x i8]], [800 x [800 x i8]]* @tmp_field, i64 0, i64 %50, i64 %40
  %54 = load i8, i8* %53, align 1, !tbaa !7
  store i8 %54, i8* %51, align 1, !tbaa !7
  store i8 %52, i8* %53, align 1, !tbaa !7
  %55 = add nuw nsw i64 %45, 2
  %56 = icmp eq i64 %55, 800
  br i1 %56, label %41, label %44, !llvm.loop !16

57:                                               ; preds = %41
  tail call void (...) @flush() #6
  %58 = tail call zeroext i1 (...) @is_open_window() #6
  br i1 %58, label %15, label %59, !llvm.loop !17

59:                                               ; preds = %57, %6
  ret i32 0
}

declare void @graph_init(...) local_unnamed_addr #1

declare zeroext i1 @is_open_window(...) local_unnamed_addr #1

declare void @window_clear(i8 noundef zeroext, i8 noundef zeroext, i8 noundef zeroext) local_unnamed_addr #1

declare void @flush(...) local_unnamed_addr #1

attributes #0 = { nounwind sspstrong uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress nofree norecurse nosync nounwind readonly sspstrong uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nofree norecurse nosync nounwind sspstrong uwtable willreturn writeonly "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nofree norecurse nosync nounwind readonly sspstrong uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree norecurse nosync nounwind sspstrong uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"clang version 14.0.6"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!8, !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !6}
!11 = distinct !{!11, !6}
!12 = distinct !{!12, !6}
!13 = distinct !{!13, !6}
!14 = distinct !{!14, !6}
!15 = distinct !{!15, !6}
!16 = distinct !{!16, !6}
!17 = distinct !{!17, !6}
