#pragma once

// Qt 5.15 uses stdext::make_checked_array_iterator / make_unchecked_array_iterator
// on MSVC, but these non-standard helpers were removed in newer MSVC STL releases.
#if defined(_MSC_VER) && _MSC_VER >= 1950
#include <cstddef>

namespace stdext
{
	template <typename Iter>
	constexpr Iter make_checked_array_iterator(Iter it, std::size_t) noexcept
	{
		return it;
	}

	template <typename Iter>
	constexpr Iter make_unchecked_array_iterator(Iter it) noexcept
	{
		return it;
	}
}
#endif
