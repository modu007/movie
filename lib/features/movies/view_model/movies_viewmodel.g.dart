// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$moviesViewModelHash() => r'375ba9290c265e36b18caf497b1f48857cb5909c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MoviesViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<Movie>> {
  late final int userId;

  FutureOr<List<Movie>> build(
    int userId,
  );
}

/// See also [MoviesViewModel].
@ProviderFor(MoviesViewModel)
const moviesViewModelProvider = MoviesViewModelFamily();

/// See also [MoviesViewModel].
class MoviesViewModelFamily extends Family<AsyncValue<List<Movie>>> {
  /// See also [MoviesViewModel].
  const MoviesViewModelFamily();

  /// See also [MoviesViewModel].
  MoviesViewModelProvider call(
    int userId,
  ) {
    return MoviesViewModelProvider(
      userId,
    );
  }

  @override
  MoviesViewModelProvider getProviderOverride(
    covariant MoviesViewModelProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'moviesViewModelProvider';
}

/// See also [MoviesViewModel].
class MoviesViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MoviesViewModel, List<Movie>> {
  /// See also [MoviesViewModel].
  MoviesViewModelProvider(
    int userId,
  ) : this._internal(
          () => MoviesViewModel()..userId = userId,
          from: moviesViewModelProvider,
          name: r'moviesViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$moviesViewModelHash,
          dependencies: MoviesViewModelFamily._dependencies,
          allTransitiveDependencies:
              MoviesViewModelFamily._allTransitiveDependencies,
          userId: userId,
        );

  MoviesViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  FutureOr<List<Movie>> runNotifierBuild(
    covariant MoviesViewModel notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(MoviesViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MoviesViewModelProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MoviesViewModel, List<Movie>>
      createElement() {
    return _MoviesViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MoviesViewModelProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MoviesViewModelRef on AutoDisposeAsyncNotifierProviderRef<List<Movie>> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _MoviesViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MoviesViewModel,
        List<Movie>> with MoviesViewModelRef {
  _MoviesViewModelProviderElement(super.provider);

  @override
  int get userId => (origin as MoviesViewModelProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
